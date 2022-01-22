//
//  SimpleContinuosCarouselCollectionCellPresenterProtocol.swift
//  Smart
//
//  Created by Михаил Исаченко on 14.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol SimpleContinuosCarouselCollectionCellPresenterProtocol: AnyObject {
  func showNetworkErrorAlert(error: Error)
  func startLoading()
  func stopLoading()
  func showAlertEmptyCollection()
  func update(model: SimpleContinuousCaruselCollectionCellViewModel)
}
