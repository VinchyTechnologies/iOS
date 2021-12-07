//
//  CantOpenURLAlertable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 07.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import StringFormatting

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
  func showAlertCantOpenEmail()
}

extension CantOpenEmailAlertable {
  public func showAlertCantOpenEmail() {
    showAlert(
      title: localized("error").firstLetterUppercased(),
      message: localized("open_mail_error"))
  }
}
