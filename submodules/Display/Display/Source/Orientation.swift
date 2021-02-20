//
//  Orientation.swift
//  Display
//
//  Created by Алексей Смирнов on 16.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

public struct Orientation {
  public static var isLandscape: Bool {
    get {
      guard let windowScence = UIApplication.shared.windows.first?.windowScene else {
        return false
      }
      return UIDevice.current.orientation.isValidInterfaceOrientation
        ? UIDevice.current.orientation.isLandscape
        : windowScence.interfaceOrientation.isLandscape
    }
  }
}
