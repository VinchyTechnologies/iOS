//
//  EnterPasswordInteractor.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 23.12.2020.
//

import VinchyCore

fileprivate enum C {
  static let timerSeconds: TimeInterval = 10
}

final class EnterPasswordInteractor {
  
  private let input: EnterPasswordInput
  private let router: EnterPasswordRouterProtocol
  private let presenter: EnterPasswordPresenterProtocol
  
  private var timer: Timer?
  private var counter = C.timerSeconds
  
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
  
  func didTapSendCodeAgainButton() {
    Accounts.shared.sendConfirmationCode(accountID: input.accountID) { [weak self] result in
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
