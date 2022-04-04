//
//  QRRoutable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 13.03.2022.
//  Copyright © 2022 Aleksei Smirnov. All rights reserved.
//

import Foundation

public protocol QRRoutable: AnyObject {
  func presentQRViewController(affilatedId: Int, wineID: Int64)
}
