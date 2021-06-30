//
//  EditProfileInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 15.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import VinchyCore

// MARK: - EditProfileInteractor

final class EditProfileInteractor {

  // MARK: Lifecycle

  init(
    router: EditProfileRouterProtocol,
    presenter: EditProfilePresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let router: EditProfileRouterProtocol
  private let presenter: EditProfilePresenterProtocol

  private var currentEditingName: String?
}

// MARK: EditProfileInteractorProtocol

extension EditProfileInteractor: EditProfileInteractorProtocol {

  func didTapSaveButton() {
    UserDefaultsConfig.userName = currentEditingName ?? ""

//    Accounts.shared.updateAccount(
//      accountID: UserDefaultsConfig.accountID,
//      refreshToken: "Keychain.shared.accessToken" ?? "",
//      accountName: currentEditingName,
//      password: nil) { result in
//        switch result {
//        case .success:
//          break
//
//        case .failure:
//          break
//        }
//    }

    router.dismiss()
  }

  func textFieldDidChanged(type: EditProfileTextFieldType, newValue: String?) {
    switch type {
    case .email:
      break

    case .name:
      currentEditingName = newValue
      if newValue != UserDefaultsConfig.userName {
        presenter.setSaveButtonEnabled(true)
      } else {
        presenter.setSaveButtonEnabled(false)
      }
    }
  }

  func viewDidLoad() {
    presenter.update(userName: UserDefaultsConfig.userName, email: UserDefaultsConfig.accountEmail)
  }
}
