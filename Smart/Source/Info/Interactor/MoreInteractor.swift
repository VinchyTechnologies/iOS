//
//  MoreInteractor.swift
//  Coffee
//
//  Created by Алексей Смирнов on 10/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//
// swiftlint:disable all

import EmailService
import StringFormatting
import Core

final class MoreInteractor: OpenURLProtocol {
  
  let vkURL = "https://vk.com"
  let instagramURL = "https://www.instagram.com"
  let openAppStoreURL = localized("appstore_link")
  
  var presenter: MorePresenterProtocol!
  private let router: MoreRouterProtocol
  let emailService: EmailServiceProtocol = EmailService()
  
  required init(presenter: MorePresenterProtocol, router: MoreRouterProtocol) {
    self.presenter = presenter
    self.router = router
  }
  
  private func openUrl(urlString: String) {
    open(urlString: urlString) {
      presenter.showAlert(message: localized("open_url_error"))
    }
  }
}

extension MoreInteractor: MoreInteractorProtocol {
  
  func rateApp() {
    openUrl(urlString: openAppStoreURL)
  }
  
  func openVk() {
    openUrl(urlString: vkURL)
  }
  
  func callUs() {
    openUrl(urlString: localized("contact_phone_url"))
  }
  
  func openInstagram() {
    openUrl(urlString: instagramURL)
  }
  
  func goToAboutController() {
    router.pushToAboutController()
  }
  
  func goToDocController() {
    router.pushToDocController()
  }
  
  func workWithUs() {
    sendEmail(HTMLText: nil)
  }
  
  func emailUs() {
    sendEmail(HTMLText: nil)
  }
  
  func viewDidLoad() {
    presenter.startCreateViewModel()
  }
  
  func sendEmail(HTMLText: String?) {
    if emailService.canSend {
      let mail = emailService.getEmailController(HTMLText: HTMLText, recipients: [localized("contact_email")])
//      presenter.present(controller: mail, completion: nil) // TODO: - WineDetailVC
    } else {
      presenter.showAlert(message: localized("open_mail_error"))
    }
  }
}
