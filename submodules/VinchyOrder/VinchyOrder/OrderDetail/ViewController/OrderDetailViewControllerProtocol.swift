//
//  OrderDetailViewControllerProtocol.swift
//  VinchyOrder
//
//  Created by Алексей Смирнов on 21.02.2022.
//

import Foundation

protocol OrderDetailViewControllerProtocol: AnyObject {
  func updateUI(viewModel: OrderDetailViewModel)
}
