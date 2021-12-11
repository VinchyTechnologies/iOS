//
//  RatesInteractorProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit.UIView

protocol RatesInteractorProtocol: AnyObject {
  func viewDidLoad()
  func viewWillAppear()
  func willDisplayLoadingView()
  func didSelectReview(wineID: Int64)
  func didTapMore(reviewID: Int)
  func didSwipeToDelete(reviewID: Int)
  func didSwipeToEdit(reviewID: Int)
  func didSwipeToShare(reviewID: Int, sourceView: UIView)
  func didPullToRefresh()
  func didTapLoginButton()
}
