//
//  MoreRouter.swift
//  Coffee
//
//  Created by Алексей Смирнов on 10/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//
// swiftlint:disable all

import Core
import Display
import StringFormatting
import UIKit

// MARK: - MoreRouter

final class MoreRouter: OpenURLProtocol {

  // MARK: Lifecycle

  init(viewController: MoreViewController) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: MoreInteractorProtocol?

  // MARK: Private

  private let emailService = EmailService()
}

// MARK: MoreRouterProtocol

extension MoreRouter: MoreRouterProtocol {

  func presentContactActionSheet(to: String, subject: String, body: String, includingThirdPartyApps: Bool, sourceView: UIView) {
    guard
      let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
      let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    else {
      return
    }

    let alert = UIAlertController(title: to, message: nil, preferredStyle: .actionSheet)

    if emailService.canSend {
      alert.addAction(UIAlertAction(title: localized("system_mail").firstLetterUppercased(), style: .default, handler: { [weak self] _ in
        guard let self = self else { return }
        let emailController = self.emailService.getEmailController(HTMLText: body, recipients: [to])
        self.viewController?.present(emailController, animated: true, completion: nil)
      }))
    }

    let gmailString = "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)"
    if let gmailUrl = URL(string: gmailString), UIApplication.shared.canOpenURL(gmailUrl) {
      alert.addAction(UIAlertAction(title: localized("google_mail").firstLetterUppercased(), style: .default, handler: { [weak self] _ in
        self?.open(urlString: gmailString, errorCompletion: {})
      }))
    }

    let yahooString = "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)"
    if let yahooUrl = URL(string: yahooString), UIApplication.shared.canOpenURL(yahooUrl) {
      alert.addAction(UIAlertAction(title: localized("yahoo_mail").firstLetterUppercased(), style: .default, handler: { [weak self] _ in
        self?.open(urlString: yahooString, errorCompletion: {})
      }))
    }

    let outlookString = "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)"
    if let outlookUrl = URL(string: outlookString), UIApplication.shared.canOpenURL(outlookUrl) {
      alert.addAction(UIAlertAction(title: localized("outlook_mail").firstLetterUppercased(), style: .default, handler: { [weak self] _ in
        self?.open(urlString: outlookString, errorCompletion: {})
      }))
    }

    let sparkString = "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)"
    if let sparkUrl = URL(string: sparkString), UIApplication.shared.canOpenURL(sparkUrl) {
      alert.addAction(UIAlertAction(title: localized("spark_mail").firstLetterUppercased(), style: .default, handler: { [weak self] _ in
        self?.open(urlString: sparkString, errorCompletion: {})
      }))
    }

    if includingThirdPartyApps {
      let telegramString = "https://t.me/aleksei_smirnov"
      if let telegramUrl = URL(string: telegramString), UIApplication.shared.canOpenURL(telegramUrl) {
        alert.addAction(UIAlertAction(title: localized("telegram").firstLetterUppercased(), style: .default, handler: { [weak self] _ in
          self?.open(urlString: telegramString, errorCompletion: {})
        }))
      }
    }

    alert.addAction(UIAlertAction(title: localized("copy").firstLetterUppercased(), style: .default, handler: { _ in
      UIPasteboard.general.string = to
    }))

    alert.addAction(UIAlertAction(title: localized("cancel").firstLetterUppercased(), style: .cancel, handler: nil))

    alert.view.tintColor = .accent

    alert.popoverPresentationController?.sourceView = sourceView
    alert.popoverPresentationController?.permittedArrowDirections = .up

    viewController?.present(alert, animated: true, completion: nil)
  }

  func presentAlertAreYouSureLogout(titleText: String?, subtitleText: String?, leadingButtonText: String?, trailingButtonText: String?) {
    let alert = UIAlertController(title: titleText, message: subtitleText, preferredStyle: .alert)
    alert.view.tintColor = .accent

    alert.addAction(UIAlertAction(title: trailingButtonText, style: .default, handler: { [weak self] _ in
      self?.interactor?.didTapLogoutOnAlert()
    }))

    alert.addAction(UIAlertAction(title: leadingButtonText, style: .cancel, handler: nil))

    viewController?.present(alert, animated: true, completion: nil)
  }

  func presentShowEditProfileViewController() {
    let rootViewController = EditProfileAssembly.assemblyModule(input: EditProfileInput(onDismiss: { [weak self] in
      self?.interactor?.viewDidLoad()
    }))
    let controller = VinchyNavigationController(rootViewController: rootViewController)
    viewController?.present(controller, animated: true)
  }

  func pushToCurrencyViewController() {
    let controller = CurrencyAssembly.assemblyModule()
    controller.hidesBottomBarWhenPushed = true
    viewController?.navigationController?.pushViewController(controller, animated: true)
  }

  func presentEmailController(HTMLText: String?, recipients: [String]) {
    let emailController = emailService.getEmailController(
      HTMLText: HTMLText,
      recipients: recipients)
    viewController?.present(emailController, animated: true, completion: nil)
  }

  func pushToAboutController() {
    let controller = AboutViewController()
    controller.hidesBottomBarWhenPushed = true
    viewController?.navigationController?.pushViewController(controller, animated: true)
  }

  func pushToDocController() {
    let controller = DocumentsAssembly.assemblyModule() //DocController()
    controller.hidesBottomBarWhenPushed = true
    viewController?.navigationController?.pushViewController(controller, animated: true)
  }

  func present(_ viewController: UIViewController, completion: (() -> Void)?) {
    self.viewController?.navigationController?.present(viewController, animated: true, completion: completion)
  }
}
