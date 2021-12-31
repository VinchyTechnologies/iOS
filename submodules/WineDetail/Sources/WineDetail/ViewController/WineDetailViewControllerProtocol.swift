//
//  WineDetailViewControllerProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import VinchyUI

protocol WineDetailViewControllerProtocol: Alertable, StatusAlertable, Loadable {
  func updateUI(viewModel: WineDetailViewModel)
  func updateLike(isLiked: Bool)
  func updateGeneralInfoSectionAndExpandOrCollapseCell(viewModel: WineDetailViewModel)
  func showReviewButtonTutorial(viewModel: DeliveryTutorialViewModel)
  func scrollToWhereToBuySections(itemDataID: AnyHashable, dataID: AnyHashable)
  func showAppClipDownloadFullApp()
}
