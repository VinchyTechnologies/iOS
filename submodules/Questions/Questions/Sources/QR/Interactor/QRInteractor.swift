//
//  QRInteractor.swift
//  Questions
//
//  Created by Алексей Смирнов on 13.03.2022.
//

import VinchyCore

// MARK: - QRInteractor

final class QRInteractor {

  // MARK: Lifecycle

  init(
    input: QRInput,
    router: QRRouterProtocol,
    presenter: QRPresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
    guard let self = self else { return }
    self.presenter.startLoading()
  }

  private let input: QRInput
  private let router: QRRouterProtocol
  private let presenter: QRPresenterProtocol

  private func loadInitData() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.dispatchWorkItemHud.perform()
    }

    Partners.shared.getPartnerStoreInfo(partnerId: 1, affilatedId: input.affilietedId) { [weak self] result in
      guard let self = self else { return }
      self.dispatchWorkItemHud.cancel()
      DispatchQueue.main.async {
        self.presenter.stopLoading()
      }
      switch result {
      case .success(let response):
        self.presenter.update(partnerInfo: response, wineID: self.input.wineID)

      case .failure(let error):
        self.presenter.update(error: error)
      }
    }
  }
}

// MARK: QRInteractorProtocol

extension QRInteractor: QRInteractorProtocol {

  func didTapReload() {
    dispatchWorkItemHud.perform()
    loadInitData()
  }

  func viewDidLoad() {
    loadInitData()
  }
}
