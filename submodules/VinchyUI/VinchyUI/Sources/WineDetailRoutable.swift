//
//  WineDeatailRoutable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 01.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

public protocol WineDetailRoutable: AnyObject {
  func pushToWineDetailViewController(wineID: Int64)
  func presentWineDetailViewController(wineID: Int64)
}
