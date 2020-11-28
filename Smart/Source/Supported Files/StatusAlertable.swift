//
//  Alertable.swift
//  Smart
//
//  Created by Aleksei Smirnov on 28.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import SPAlert

public struct StatusAlertViewModel {
  let image: UIImage?
  let titleText: String?
  let descriptionText: String?
}

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
