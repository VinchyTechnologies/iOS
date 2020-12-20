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
  let emailService: EmailServiceProtocol = EmailService()
  private let router: MoreRouterProtocol
  
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
  
  func didTapRateApp() {
    openUrl(urlString: openAppStoreURL)
  }
  
  func didTapOpenVk() {
    openUrl(urlString: vkURL)
  }
  
  func didTapCallUs() {
    openUrl(urlString: localized("contact_phone_url"))
  }
  
  func didTapOpenInstagram() {
    openUrl(urlString: instagramURL)
  }
  
  func didTapAboutApp() {
    router.pushToAboutController()
  }
  
  func didTapDoc() {
    router.pushToDocController()
  }
  
  func didTapworkWithUs() {
    didTapSendEmail(HTMLText: nil)
  }
  
  func didTapEmailUs() {
    didTapSendEmail(HTMLText: nil)
  }
  
  func viewDidLoad() {
    presenter.startCreateViewModel()
  }
  
  func didTapSendEmail(HTMLText: String?) {
      
      if emailService.canSend {
        router.presentEmailController(HTMLText: HTMLText, recipients: [localized("contact_email")])
      } else {
        presenter.showAlert(message: localized("error").firstLetterUppercased())
      }
    }  
  }

