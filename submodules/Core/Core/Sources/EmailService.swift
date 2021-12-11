//
//  EmailService.swift
//  Core
//
//  Created by Алексей Смирнов on 12.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import MessageUI

// MARK: - EmailServiceProtocol

public protocol EmailServiceProtocol: AnyObject {
  var canSend: Bool { get }

  func getEmailController(
    HTMLText: String?,
    recipients: [String])
    -> MFMailComposeViewController
}

// MARK: - EmailService

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

// MARK: MFMailComposeViewControllerDelegate

extension EmailService: MFMailComposeViewControllerDelegate {
  public func mailComposeController(
    _ controller: MFMailComposeViewController,
    didFinishWith _: MFMailComposeResult,
    error _: Error?)
  {
    controller.dismiss(animated: true, completion: nil)
  }
}
