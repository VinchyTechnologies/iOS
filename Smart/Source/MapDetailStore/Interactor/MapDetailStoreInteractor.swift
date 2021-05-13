//
//  MapDetailStoreInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import VinchyCore

final class MapDetailStoreInteractor {
  
  private let input: MapDetailStoreInput
  private let router: MapDetailStoreRouterProtocol
  private let presenter: MapDetailStorePresenterProtocol
  
  private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
    guard let self = self else { return }
    self.presenter.startLoading()
  }
  
  init(
    input: MapDetailStoreInput,
    router: MapDetailStoreRouterProtocol,
    presenter: MapDetailStorePresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
  }
  
  private func loadStoreInfo() {
    dispatchWorkItemHud.perform()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      Partners.shared.getPartnerStoreInfo(
        partnerId: self.input.partnerId,
        affilatedId: self.input.affilatedId) { [weak self] result in
        guard let self = self else { return }
        
        self.dispatchWorkItemHud.cancel()
        DispatchQueue.main.async {
          self.presenter.stopLoading()
        }
        switch result {
        case .success(let storeInfo):
          self.presenter.update(storeInfo: storeInfo)
          
        case .failure(let error):
          break
        }
      }
    }
  }
}

// MARK: - MapDetailStoreInteractorProtocol

extension MapDetailStoreInteractor: MapDetailStoreInteractorProtocol {
  
  func viewDidLoad() {
    loadStoreInfo()
  }
}
