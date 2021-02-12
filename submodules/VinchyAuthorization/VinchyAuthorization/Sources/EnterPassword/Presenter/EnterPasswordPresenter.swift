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
  
  func startLoading() {
    viewController?.startLoadingAnimation()
    viewController?.addLoader()
  }
  
  func stopLoading() {
    viewController?.stopLoadingAnimation()
  }
  
  func updateButtonTitle(seconds: TimeInterval) {
    viewController?.updateUI(
      buttonText: (seconds == 0 ? localized("send_code_again", bundle: Bundle(for: type(of: self))) : timeFormatter.string(from: seconds)) ?? "",
      isButtonEnabled: seconds == 0)
  }
  
  func update() {
    let viewModel = EnterPasswordViewModel(
      titleText: nil,
      subtitleText: localized(
        "enter_the_code_received_by_email",
        bundle: Bundle(for: type(of: self))),
      enterPasswordTextFiledPlaceholderText: localized(
        "enter_the_code",
        bundle: Bundle(for: type(of: self))),
      enterPasswordTextFiledTopPlaceholderText: localized(
        "code",
        bundle: Bundle(for: type(of: self))))
    
    viewController?.updateUI(viewModel: viewModel)
  }
  
  func showAlertErrorWhileSendingCode(error: Error) {
    viewController?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: error.localizedDescription)
  }
}
