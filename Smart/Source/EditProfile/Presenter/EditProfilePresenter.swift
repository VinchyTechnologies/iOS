//
//  EditProfilePresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 15.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
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
  func update(userName: String?, email: String) {
    var sections = [EditProfileViewModel.Section]()

    sections += [
      .commonEditCell([
        .title(text: NSAttributedString(string: "UserName", font: Font.medium(16), textColor: .dark)),
        .textField(text: userName),
      ]),
    ]

    sections += [
      .commonEditCell([
        .title(text: NSAttributedString(string: "Email", font: Font.medium(16), textColor: .dark)),
        .textField(text: email),
      ]),
    ]

    let viewModel = EditProfileViewModel(sections: sections, navigationTitle: "Edit profile", saveButtonText: localized("save").firstLetterUppercased())
    viewController?.updateUI(viewModel: viewModel)
  }
}
