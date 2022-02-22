//
//  CartRouterProtocol.swift
//  VinchyCart
//
//  Created by Алексей Смирнов on 11.02.2022.
//

import VinchyCore

protocol CartRouterProtocol: AnyObject {
  func presentWineDetail(wineID: Int64, affilatedId: Int, price: Price)
}
