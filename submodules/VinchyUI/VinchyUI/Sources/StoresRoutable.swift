//
//  StoresRoutable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 02.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

public protocol StoresRoutable {
  func pushToStoresViewController(wineID: Int64)
}
