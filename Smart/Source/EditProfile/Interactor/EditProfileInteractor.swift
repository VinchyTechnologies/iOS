//
//  EditProfileInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 15.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core

final class EditProfileInteractor {
  
  private let router: EditProfileRouterProtocol
  private let presenter: EditProfilePresenterProtocol
  
  init(
    router: EditProfileRouterProtocol,
    presenter: EditProfilePresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }
}

// MARK: - EditProfileInteractorProtocol

extension EditProfileInteractor: EditProfileInteractorProtocol {
  
  func viewDidLoad() {
    presenter.update(userName: UserDefaultsConfig.userName, email: UserDefaultsConfig.accountEmail)
  }
}
