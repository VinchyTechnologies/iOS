//
//  EditProfilePresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 15.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import StringFormatting

// MARK: - EditProfilePresenter

final class EditProfilePresenter {

  // MARK: Lifecycle

  init(viewController: EditProfileViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: EditProfileViewControllerProtocol?

  // MARK: Private

  private typealias ViewModel = EditProfileViewModel
}

// MARK: EditProfilePresenterProtocol

extension EditProfilePresenter: EditProfilePresenterProtocol {

  func setSaveButtonEnabled(_ flag: Bool) {
    viewController?.setSaveButtonEnabled(flag)
  }

  func update(userName: String?, email: String) {
    var sections = [EditProfileViewModel.Section]()

    sections += [
      .commonEditCell([
        .title(text: NSAttributedString(string: localized("username").firstLetterUppercased(), font: Font.medium(16), textColor: .dark)),
        .textField(model: .init(recognizableIdentificator: EditProfileTextFieldType.name.rawValue, text: userName, placeholder: localized("add").firstLetterUppercased(), isEditable: true)),
      ]),
    ]

    sections += [
      .commonEditCell([
        .title(text: NSAttributedString(string: "Email", font: Font.medium(16), textColor: .dark)),
        .textField(model: .init(recognizableIdentificator: EditProfileTextFieldType.email.rawValue, text: email, placeholder: nil, isEditable: false)),
      ]),
    ]

    sections += [
      .deleteAccount([LogOutCellViewModel(titleText: "Delete Account")]),
    ]

    let viewModel = EditProfileViewModel(sections: sections, navigationTitle: localized("edit_profile"), saveButtonText: localized("save").firstLetterUppercased())
    viewController?.updateUI(viewModel: viewModel)
  }
}
