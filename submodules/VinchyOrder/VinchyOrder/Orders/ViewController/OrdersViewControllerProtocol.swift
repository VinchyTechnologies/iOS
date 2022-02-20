//
//  OrdersViewControllerProtocol.swift
//  VinchyOrder
//
//  Created by Алексей Смирнов on 20.02.2022.
//

import DisplayMini

protocol OrdersViewControllerProtocol: Loadable, Alertable {
  func updateUI(viewModel: OrdersViewModel)
}
