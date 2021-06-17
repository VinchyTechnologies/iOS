//
//  ReviewDetailInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 21.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

// MARK: - ReviewDetailInteractor

final class ReviewDetailInteractor {

  // MARK: Lifecycle

  init(
    router: ReviewDetailRouterProtocol,
    presenter: ReviewDetailPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let router: ReviewDetailRouterProtocol
  private let presenter: ReviewDetailPresenterProtocol
}

// MARK: ReviewDetailInteractorProtocol

extension ReviewDetailInteractor: ReviewDetailInteractorProtocol {
  func viewDidLoad() {
    presenter.update()
  }
}
