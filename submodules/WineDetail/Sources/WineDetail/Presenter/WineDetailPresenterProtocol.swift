//
//  WineDetailPresenterProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import VinchyCore

protocol WineDetailPresenterProtocol: AnyObject {
  var reportAnErrorRecipients: [String] { get }
  var reportAnErrorText: String? { get }
  var dislikeText: String? { get }
  func startLoading()
  func stopLoading()
  func update(wine: Wine, reviews: [Review]?, isLiked: Bool, isDisliked: Bool, rating: Rating?, currency: String, stores: [PartnerInfo]?, isGeneralInfoCollapsed: Bool)
  func showAlertCantOpenEmail()
  func showNetworkErrorAlert(error: Error)
  func showAlertWineAlreadyDisliked()
  func showAlertWineAlreadyLiked()
  func showStatusAlertDidLikedSuccessfully()
  func setLikedStatus(isLiked: Bool)
  func showStatusAlertDidDislikedSuccessfully()
  func expandOrCollapseGeneralInfo(wine: Wine, isGeneralInfoCollapsed: Bool)
  func showReviewButtonTutorial()
  func scrollToWhereToBuySections()
  func showAppClipDownloadFullApp()
}
