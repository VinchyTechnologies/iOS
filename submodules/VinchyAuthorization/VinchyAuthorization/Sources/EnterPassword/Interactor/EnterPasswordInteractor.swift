//
//  EnterPasswordInteractor.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 23.12.2020.
//

import Foundation

final class EnterPasswordInteractor {
  
  private let router: EnterPasswordRouterProtocol
  private let presenter: EnterPasswordPresenterProtocol
  
  init(
    router: EnterPasswordRouterProtocol,
    presenter: EnterPasswordPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }
}

// MARK: - EnterPasswordInteractorProtocol

extension EnterPasswordInteractor: EnterPasswordInteractorProtocol {
  
  func viewDidLoad() {
    presenter.update()
  }
}
