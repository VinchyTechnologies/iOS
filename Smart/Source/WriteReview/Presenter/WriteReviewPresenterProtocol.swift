//
//  WriteReviewPresenterProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 22.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol WriteReviewPresenterProtocol: AnyObject {
  var statusAlertViewModelAfterCreate: StatusAlertViewModel { get }
  var statusAlertViewModelAfterUpdate: StatusAlertViewModel { get }
  func setPlaceholder()
  func update(rating: Double, comment: String?)
  func showAlertErrorWhileCreatingReview(error: Error)
  func showAlertErrorWhileUpdatingReview(error: Error)
  func startLoading()
  func stopLoading()
}
