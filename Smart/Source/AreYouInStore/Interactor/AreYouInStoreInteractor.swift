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
    router: AreYouInStoreRouterProtocol,
    presenter: AreYouInStorePresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let router: AreYouInStoreRouterProtocol
  private let presenter: AreYouInStorePresenterProtocol

}

// MARK: AreYouInStoreInteractorProtocol

extension AreYouInStoreInteractor: AreYouInStoreInteractorProtocol {

  func viewDidLoad() {
    presenter.update(title: "Кажется, Вы в магазине \"Пятерочка\"?")
  }
}
