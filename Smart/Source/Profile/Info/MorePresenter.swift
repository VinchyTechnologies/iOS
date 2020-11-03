//
//  MorePresenter.swift
//  Coffee
//
//  Created by Алексей Смирнов on 10/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//
// swiftlint:disable all

import UIKit
import Core
import StringFormatting

let vkURL = "https://vk.com"
let instagramURL = "https://www.instagram.com"
let openAppStoreURL = localized("appstore_link")

protocol MorePresenterProtocol: AnyObject {
  func rateApp()
  func openVk()
  func openInstagram()
  func callUs()
  func showAlert(message: String)
  func present(controller: UIViewController, completion: (() -> Void)?)
  func emailUs()
  func workWithUs()
  func goToDocController()
  func goToAboutController()
}

final class MorePresenter: OpenURLProtocol {
  
  // MARK: - Properties
  
  weak var view: MoreViewProtocol!
  var interactor: MoreInteractorProtocol!
  var router: MoreRouterProtocol!
  
  // MARK: - Lifecycle
  
  required init(view: MoreViewProtocol) {
    self.view = view
  }
  
  private func openUrl(urlString: String) {
    open(urlString: urlString) {
      view.presentAlert(message: localized("open_url_error"))
    }
  }
  
  private func sendEmail(with HTMLText: String?) {
    interactor.sendEmail(HTMLText: HTMLText)
  }
}

extension MorePresenter: MorePresenterProtocol {
  
  func goToAboutController() {
    router.pushToAboutController()
  }
  
  func goToDocController() {
    router.pushToDocController()
  }
  
  func workWithUs() {
    sendEmail(with: nil)
  }
  
  func emailUs() {
    sendEmail(with: nil)
  }
  
  func showAlert(message: String) {
    view.presentAlert(message: message)
  }
  
  func present(controller: UIViewController, completion: (() -> Void)?) {
    router.present(controller, completion: nil)
  }
  
  func callUs() {
    openUrl(urlString: localized("contact_phone_url"))
  }
  
  func rateApp() {
    openUrl(urlString: openAppStoreURL)
  }
  
  func openVk() {
    openUrl(urlString: vkURL)
  }
  
  func openInstagram() {
    openUrl(urlString: instagramURL)
  }
}
