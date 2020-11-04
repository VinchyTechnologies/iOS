//
//  EmailService.swift
//  EmailService
//
//  Created by Aleksei Smirnov on 20.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import MessageUI

public protocol EmailServiceProtocol: AnyObject {

  var canSend: Bool { get }

  func getEmailController(
    HTMLText: String?,
    recipients: [String])
    -> MFMailComposeViewController
}

public final class EmailService: NSObject, EmailServiceProtocol {

  public var canSend: Bool {
    MFMailComposeViewController.canSendMail()
  }

  public func getEmailController(
    HTMLText: String?,
    recipients: [String])
    -> MFMailComposeViewController
  {
    let mail = MFMailComposeViewController()
    mail.setToRecipients(recipients)
    if let HTMLText = HTMLText {
      mail.setMessageBody(HTMLText, isHTML: true)
    }
    mail.mailComposeDelegate = self
    return mail
  }
}

extension EmailService: MFMailComposeViewControllerDelegate {

  public func mailComposeController(
    _ controller: MFMailComposeViewController,
    didFinishWith result: MFMailComposeResult,
    error: Error?)
  {
    controller.dismiss(animated: true, completion: nil)
  }
}
