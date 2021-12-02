//
//  StatusAlertable.swift
//  WineDetail
//
//  Created by Алексей Смирнов on 02.12.2021.
//

import Display
import SPAlert
import StringFormatting
import UIKit

// MARK: - StatusAlertViewModel

public struct StatusAlertViewModel {
  public let image: UIImage?
  public let titleText: String?
  public let descriptionText: String?

  public init(image: UIImage?, titleText: String?, descriptionText: String?) {
    self.image = image
    self.titleText = titleText
    self.descriptionText = descriptionText
  }
}

// MARK: - StatusAlertable

public protocol StatusAlertable {
  func showStatusAlert(viewModel: StatusAlertViewModel)
}

extension StatusAlertable {
  public func showStatusAlert(viewModel: StatusAlertViewModel) {
    let alertView = SPAlertView(
      title: viewModel.titleText ?? "",
      message: viewModel.descriptionText,
      image: viewModel.image ?? UIImage())
    alertView.haptic = .success
    alertView.keyWindow = UIApplication.shared.asKeyWindow ?? UIWindow()
    alertView.duration = 1.5
    alertView.present()
  }
}

// MARK: - CantOpenURLAlertable

public protocol CantOpenURLAlertable: Alertable {
  func showAlertCantOpenURL()
}

extension CantOpenURLAlertable {
  public func showAlertCantOpenURL() {
    showAlert(
      title: localized("error").firstLetterUppercased(),
      message: localized("open_url_error"))
  }
}

// MARK: - CantOpenEmailAlertable

public protocol CantOpenEmailAlertable: Alertable {
  func showAlertCantOpenURL()
}

extension CantOpenEmailAlertable {
  public func showAlertCantOpenEmail() {
    showAlert(
      title: localized("error").firstLetterUppercased(),
      message: localized("open_mail_error"))
  }
}
