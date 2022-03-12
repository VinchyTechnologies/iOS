//
//  CartInteractorProtocol.swift
//  VinchyCart
//
//  Created by Алексей Смирнов on 11.02.2022.
//

import Database

protocol CartInteractorProtocol: AnyObject {
  func viewDidLoad()
  func didSelectHorizontalWine(wineID: Int64)
  func didTapConfirmOrderButton()
  func didTapStepper(productID: Int64, type: CartItem.Kind, value: Int)
  func getCountOfProduct(productID: Int64, type: CartItem.Kind) -> Int
  func didTapTrashButton()
}
