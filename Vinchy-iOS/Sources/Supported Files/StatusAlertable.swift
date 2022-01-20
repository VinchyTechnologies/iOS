//
//  StatusAlertable.swift
//  Smart
//
//  Created by Алексей Смирнов on 07.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import SPAlert
import VinchyUI

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
