//
//  ShowAlertPresentable.swift
//  Smart
//
//  Created by Михаил Исаченко on 02.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import StringFormatting

// MARK: - ShowAlertPresentable

protocol ShowNetworkAlertPresentable {
  func showNetworkErrorAlert(error: Error)
}
