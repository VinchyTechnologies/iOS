//
//  OrdersPresenterProtocol.swift
//  VinchyOrder
//
//  Created by Алексей Смирнов on 20.02.2022.
//

import VinchyCore

protocol OrdersPresenterProtocol: AnyObject {
  func showErrorAlert(error: Error)
  func showInitiallyLoadingError(error: Error)
  func showNothingFoundErrorView()
  func update(orders: [Order], needLoadMore: Bool)
  func startLoading()
  func stopLoading()
}
