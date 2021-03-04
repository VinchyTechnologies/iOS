//
//  EnterPasswordInteractor.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 23.12.2020.
//

import VinchyCore
import Core

fileprivate enum C {
  static let timerSeconds: TimeInterval = 60
  static let numberOfDigitsInCode = 4
}

final class EnterPasswordInteractor {
  
  private let input: EnterPasswordInput
  private let router: EnterPasswordRouterProtocol
  private let presenter: EnterPasswordPresenterProtocol
  
  private var timer: Timer?
  private var counter = C.timerSeconds
  
  private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
    guard let self = self else { return }
    self.presenter.startLoading()
  }
  
  init(
    input: EnterPasswordInput,
    router: EnterPasswordRouterProtocol,
    presenter: EnterPasswordPresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
  }
  
  @objc
  private func timerDidChange(_ timer: Timer) {
    counter -= 1
    presenter.updateButtonTitle(seconds: counter)
    if counter == 0 {
      timer.invalidate()
    }
  }
  
  private func startTimer() {
    timer?.invalidate()
    timer = Timer.scheduledTimer(
      timeInterval: 1.0,
      target: self,
      selector: #selector(timerDidChange(_:)),
      userInfo: nil,
      repeats: true)
  }  
}

// MARK: - EnterPasswordInteractorProtocol

extension EnterPasswordInteractor: EnterPasswordInteractorProtocol {
  
  func didEnterCodeInTextField(_ text: String?) {
    if let text = text, text.count == C.numberOfDigitsInCode && text.isNumeric {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.dispatchWorkItemHud.perform()
      }
      Accounts.shared.activateAccount(
        accountID: input.accountID,
        confirmationCode: text) { [weak self] result in
        self?.dispatchWorkItemHud.cancel()
        DispatchQueue.main.async {
          self?.presenter.stopLoading()
        }
        switch result {
        case .success(let model):
          Keychain.shared.accessToken = model.accessToken
          Keychain.shared.refreshToken = model.refreshToken
          Keychain.shared.password = self?.input.password
          UserDefaultsConfig.accountEmail = model.email
          UserDefaultsConfig.accountID = model.accountID
          self?.router.dismissAndRequestSuccess(output: .init(accountID: model.accountID, email: model.email))
          
        case .failure(let error):
          self?.presenter.showAlertErrorWhileSendingCode(error: error)
        }
      }
    }
  }
  
  func didTapSendCodeAgainButton() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.dispatchWorkItemHud.perform()
    }
    
    Accounts.shared.sendConfirmationCode(accountID: input.accountID) { [weak self] result in
      self?.dispatchWorkItemHud.cancel()
      DispatchQueue.main.async {
        self?.presenter.stopLoading()
      }
      switch result {
      case .success:
        self?.counter = C.timerSeconds
        self?.startTimer()
        
      case .failure(let error):
        self?.presenter.showAlertErrorWhileSendingCode(error: error)
        self?.counter = 1
        self?.startTimer()
      }
    }
  }
  
  func viewDidLoad() {
    startTimer()
    presenter.update()
  }
}

fileprivate extension String {
   var isNumeric: Bool {
     !(self.isEmpty) && self.allSatisfy { $0.isNumber }
   }
}
