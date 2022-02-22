//
//  WineDeatailRoutable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 01.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import VinchyCore

// MARK: - WineDetailRoutable

public protocol WineDetailRoutable: AnyObject {
  func pushToWineDetailViewController(wineID: Int64, mode: WineDetailMode, shouldShowSimilarWine: Bool)
  func presentWineDetailViewController(wineID: Int64, mode: WineDetailMode, shouldShowSimilarWine: Bool)
}

// MARK: - WineDetailMode

public enum WineDetailMode {

  public enum BuyAction {
    case openURL(url: URL?)
    case cart(affilatedId: Int, price: Price)
    case none
  }

  case normal
  case partner(affilatedId: Int, price: Price, buyAction: BuyAction)
}
