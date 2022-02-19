//
//  CartViewControllerProtocol.swift
//  VinchyCart
//
//  Created by Алексей Смирнов on 11.02.2022.
//

import Foundation

protocol CartViewControllerProtocol: AnyObject {
  func updateUI(viewModel: CartViewModel)
}
