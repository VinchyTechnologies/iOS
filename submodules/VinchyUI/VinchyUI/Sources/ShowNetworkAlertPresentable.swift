//
//  ShowNetworkAlertPresentable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 01.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

public protocol ShowNetworkAlertPresentable: AnyObject {
  func showNetworkErrorAlert(error: Error)
}
