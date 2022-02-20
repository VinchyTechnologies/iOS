//
//  OrdersInteractorProtocol.swift
//  VinchyOrder
//
//  Created by Алексей Смирнов on 20.02.2022.
//

import Foundation

protocol OrdersInteractorProtocol: AnyObject {
  func viewDidLoad()
  func willDisplayLoadingView()
  func didSelectOrder(orderID: Int)
}
