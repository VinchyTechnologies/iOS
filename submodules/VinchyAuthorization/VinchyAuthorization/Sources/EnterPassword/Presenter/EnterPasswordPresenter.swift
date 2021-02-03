//
//  EnterPasswordPresenter.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 23.12.2020.
//

import StringFormatting

final class EnterPasswordPresenter {
  
  private lazy var timeFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.minute, .second]
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = [.pad]
    return formatter
  }()
    
  weak var viewController: EnterPasswordViewControllerProtocol?
  
  init(viewController: EnterPasswordViewControllerProtocol) {
    self.viewController = viewController
  }
}

// MARK: - EnterPasswordPresenterProtocol

extension EnterPasswordPresenter: EnterPasswordPresenterProtocol {
  
  func updateButtonTitle(seconds: TimeInterval) {
    viewController?.updateUI(
      buttonText: (seconds == 0 ? "Send code again" : timeFormatter.string(from: seconds)) ?? "",
      isButtonEnabled: seconds == 0)
  }
  
  func update() {
    let viewModel = EnterPasswordViewModel(
      titleText: nil,//"Glad to see you again",
      subtitleText: "Enter code received in email",
      enterPasswordTextFiledPlaceholderText: "Enter code",
      enterPasswordTextFiledTopPlaceholderText: "Code",
      continueButtonText: "Confirm",
      rightBarButtonItemText: "Send code again")
    
    viewController?.updateUI(viewModel: viewModel)
  }
  
  func showAlertErrorWhileSendingCode(error: Error) {
    viewController?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: error.localizedDescription)
  }
}
