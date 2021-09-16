//
//  AreYouInStoreInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 30.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

// MARK: - AreYouInStoreInteractor

final class AreYouInStoreInteractor {

  // MARK: Lifecycle

  init(
    input: AreYouInStoreInput,
    router: AreYouInStoreRouterProtocol,
    presenter: AreYouInStorePresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let input: AreYouInStoreInput
  private let router: AreYouInStoreRouterProtocol
  private let presenter: AreYouInStorePresenterProtocol

}

// MARK: AreYouInStoreInteractorProtocol

extension AreYouInStoreInteractor: AreYouInStoreInteractorProtocol {

  func didTapBottle(wineID: Int64) {
    router.presentWineDetailViewController(wineID: wineID)
  }

  func didTapStoreButton() {
    router.presentStore(affilatedId: input.partner.partner.affiliatedStoreId)
  }

  func viewDidLoad() {
    presenter.update()
  }
}
