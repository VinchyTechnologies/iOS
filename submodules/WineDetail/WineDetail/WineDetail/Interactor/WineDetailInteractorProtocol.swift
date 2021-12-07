//
//  WineDetailInteractorProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import VinchyUI

protocol WineDetailInteractorProtocol: /*AnalyticsTrackable,*/ WineViewContextMenuTappable {
  func viewDidLoad()
  func didTapLikeButton(_ button: UIButton)
  func didTapDislikeButton()
  func didTapShareButton(_ button: UIButton)
  func didTapNotes()
  func didTapMore(_ button: UIButton)
  func didTapPriceButton()
  func didTapReportAnError(sourceView: UIView)
  func didTapSimilarWine(wineID: Int64)
  func didTapWriteReviewButton()
  func didTapSeeAllReviews()
  func didTapReview(reviewID: Int)
  func didSuccessfullyLoginOrRegister()
  func didTapStarsRatingControl()
  func didTapExpandOrCollapseGeneralInfo()
  func didScrollStopped()
  func didShowTutorial()
  func didSelectStore(affilatedId: Int)
  func didSelectWine(wineID: Int64)
  func didTapSeeAllStores()
  func requestShowStatusAlert(viewModel: StatusAlertViewModel)
}
