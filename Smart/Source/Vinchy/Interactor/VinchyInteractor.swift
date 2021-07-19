//
//  VinchyInteractor.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core
import Database
import VinchyCore


// MARK: - VinchyInteractor

final class VinchyInteractor {

  // MARK: Lifecycle

  init(
    router: VinchyRouterProtocol,
    presenter: VinchyPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let dispatchGroup = DispatchGroup()
  private let emailService = EmailService()
  private let throttler = Throttler()

  private let router: VinchyRouterProtocol
  private let presenter: VinchyPresenterProtocol

  private var compilations: [Compilation] = []

  private func fetchData() {
    dispatchGroup.enter()

    var compilations: [Compilation] = []

    Compilations.shared.getCompilations { [weak self] result in
      switch result {
      case .success(let model):
        compilations = model

      case .failure(let error):
        print(error.localizedDescription)
      }

      self?.dispatchGroup.leave()
    }

    dispatchGroup.notify(queue: .main) { [weak self] in
      guard let self = self else { return }

      if isShareUsEnabled {
        let shareUs = Compilation(type: .shareUs, title: nil, collectionList: [])
        compilations.insert(shareUs, at: compilations.isEmpty ? 0 : min(3, compilations.count - 1))
      }

      if isSmartFilterAvailable {
        let smartFilter = Compilation(type: .smartFilter, title: nil, collectionList: [])
        compilations.insert(smartFilter, at: 1)
      }

      self.compilations = compilations
      self.presenter.update(compilations: compilations)
    }
  }
}

// MARK: VinchyInteractorProtocol

extension VinchyInteractor: VinchyInteractorProtocol {
  func didSelectResultCell(wineID: Int64, title: String) {

    let maxId = searchedWinesRepository.findAll().map { $0.id }.max() ?? 0
    let id = maxId + 1
    searchedWinesRepository.append(VSearchedWine(id: id, wineID: wineID, title: title))

  }

  func viewDidLoad() {
    presenter.startShimmer()
    fetchData()
  }

  func didPullToRefresh() {
    fetchData()
    presenter.stopPullRefreshing()
  }

  func didTapFilter() {
    router.pushToAdvancedFilterViewController()
  }

  func didTapDidnotFindWineFromSearch(searchText: String?) {
    guard let searchText = searchText else {
      return
    }

    if emailService.canSend {
      router.presentEmailController(
        HTMLText: presenter.cantFindWineText + searchText,
        recipients: presenter.cantFindWineRecipients)
    } else {
      presenter.showAlertCantOpenEmail()
    }
  }

  func didTapMapButton() {
    router.pushToMapViewController()
  }
}

// MARK: - VinchySimpleConiniousCaruselCollectionCellDelegate

extension VinchyInteractor {
  func didTapBottleCell(wineID: Int64) {
    router.pushToWineDetailViewController(wineID: wineID)
  }

  func didTapCompilationCell(wines: [ShortWine], title: String?) {
    guard !wines.isEmpty else {
      presenter.showAlertEmptyCollection()
      return
    }

    router.pushToShowcaseViewController(input: .init(title: title, mode: .normal(wines: wines)))
  }
}
