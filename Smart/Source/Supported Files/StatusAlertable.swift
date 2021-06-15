//
//  Alertable.swift
//  Smart
//
//  Created by Aleksei Smirnov on 28.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import SPAlert
import StringFormatting

// MARK: - StatusAlertViewModel

public struct StatusAlertViewModel {
  let image: UIImage?
  let titleText: String?
  let descriptionText: String?
}

// MARK: - StatusAlertable

protocol StatusAlertable {
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

protocol CantOpenURLAlertable: Alertable {
  func showAlertCantOpenURL()
}

extension CantOpenURLAlertable {
  func showAlertCantOpenURL() {
    showAlert(
      title: localized("error").firstLetterUppercased(),
      message: localized("open_url_error"))
  }
}

// MARK: - CantOpenEmailAlertable

protocol CantOpenEmailAlertable: Alertable {
  func showAlertCantOpenURL()
}

extension CantOpenEmailAlertable {
  func showAlertCantOpenEmail() {
    showAlert(
      title: localized("error").firstLetterUppercased(),
      message: localized("open_mail_error"))
  }
}
