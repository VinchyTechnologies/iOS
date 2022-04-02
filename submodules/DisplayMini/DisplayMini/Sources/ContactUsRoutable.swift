//
//  ContactUsRoutable.swift
//  Display
//
//  Created by Алексей Смирнов on 11.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import StringFormatting
import UIKit.UIView

// MARK: - ContactUsRoutable

public protocol ContactUsRoutable: OpenURLProtocol {
  var viewController: UIViewController? { get }
  var emailService: EmailService { get set }
  func presentContactActionSheet(to: String, subject: String, body: String, includingThirdPartyApps: Bool, sourceView: UIView)
}

extension ContactUsRoutable {
  public func presentContactActionSheet(to: String, subject: String, body: String, includingThirdPartyApps: Bool, sourceView: UIView) {
    guard
      let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
      let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    else {
      return
    }

//    let emailService = EmailService()

    let alert = UIAlertController(title: to, message: nil, preferredStyle: .actionSheet)

    if emailService.canSend {
      alert.addAction(UIAlertAction(title: localized("system_mail").firstLetterUppercased(), style: .default, handler: { _ in
        let emailController = emailService.getEmailController(HTMLText: body, recipients: [to])
        viewController?.present(emailController, animated: true, completion: nil)
      }))
    }

    let gmailString = "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)"
    if let gmailUrl = URL(string: gmailString), UIApplication.shared.canOpenURL(gmailUrl) {
      alert.addAction(UIAlertAction(title: localized("google_mail").firstLetterUppercased(), style: .default, handler: { _ in
        open(urlString: gmailString, errorCompletion: {})
      }))
    }

    let yahooString = "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)"
    if let yahooUrl = URL(string: yahooString), UIApplication.shared.canOpenURL(yahooUrl) {
      alert.addAction(UIAlertAction(title: localized("yahoo_mail").firstLetterUppercased(), style: .default, handler: { _ in
        open(urlString: yahooString, errorCompletion: {})
      }))
    }

    let outlookString = "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)"
    if let outlookUrl = URL(string: outlookString), UIApplication.shared.canOpenURL(outlookUrl) {
      alert.addAction(UIAlertAction(title: localized("outlook_mail").firstLetterUppercased(), style: .default, handler: { _ in
        open(urlString: outlookString, errorCompletion: {})
      }))
    }

    let sparkString = "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)"
    if let sparkUrl = URL(string: sparkString), UIApplication.shared.canOpenURL(sparkUrl) {
      alert.addAction(UIAlertAction(title: localized("spark_mail").firstLetterUppercased(), style: .default, handler: { _ in
        open(urlString: sparkString, errorCompletion: {})
      }))
    }

    if includingThirdPartyApps {
      let telegramString = "https://t.me/aleksei_smirnov"
      if let telegramUrl = URL(string: telegramString), UIApplication.shared.canOpenURL(telegramUrl) {
        alert.addAction(UIAlertAction(title: localized("telegram").firstLetterUppercased(), style: .default, handler: { _ in
          open(urlString: telegramString, errorCompletion: {})
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

}
