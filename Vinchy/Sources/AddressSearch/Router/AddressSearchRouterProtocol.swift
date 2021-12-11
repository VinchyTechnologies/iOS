//
//  AddressSearchRouterProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 30.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol AddressSearchRouterProtocol: AnyObject {
  func dismiss()
  func showAlertTurnOnLocationViaSettingOnly(titleText: String?, subtitleText: String?, leadingButtonText: String?, trailingButtonText: String?)
}
