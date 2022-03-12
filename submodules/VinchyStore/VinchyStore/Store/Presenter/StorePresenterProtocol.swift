//
//  StorePresenterProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Database
import UIKit
import VinchyUI

protocol StorePresenterProtocol: ShowNetworkAlertPresentable {
  func update(data: StoreInteractorData, needLoadMore: Bool, isBottomButtonLoading: Bool, totalPrice: Int64?, cartItems: [CartItem], recommendedWinesContentOffsetX: CGFloat)
  func startLoading()
  func stopLoading()
  func showErrorAlert(error: Error)
  func showInitiallyLoadingError(error: Error)
  func setLoadingFilters(data: StoreInteractorData)
  func setLikedStatus(isLiked: Bool)
}
