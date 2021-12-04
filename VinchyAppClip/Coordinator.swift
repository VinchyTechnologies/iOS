//
//  Coordinator.swift
//  VinchyAppClip
//
//  Created by Алексей Смирнов on 04.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import AdvancedSearch
import Database
import Display
import FittedSheets
import UIKit
import VinchyCore
import VinchyUI
import WineDetail

final class Coordinator: WineDetailRoutable, ActivityRoutable, WriteNoteRoutable, AdvancedSearchRoutable, ResultsSearchRoutable, ReviewDetailRoutable, ReviewsRoutable, StoreRoutable, StoresRoutable, WriteReviewRoutable, ShowcaseRoutable {

  static let shared = Coordinator()


  func presentAdvancedSearch(input: AdvancedSearchInput, delegate: AdvancedSearchOutputDelegate?) {
    let controller = AdvancedSearchAssembly.assemblyModule(
      input: input,
      coordinator: Coordinator.shared)
    let navController = AdvancedSearchNavigationController(rootViewController: controller)
    navController.advancedSearchOutputDelegate = delegate
    UIApplication.topViewController()?.present(navController, animated: true, completion: nil)
  }

  func pushToResultsSearchController(affilatedId: Int) {

  }

  func showBottomSheetReviewDetailViewController(reviewInput: ReviewDetailInput) {
    let options = SheetOptions(shrinkPresentingViewController: false)
    let reviewDetailViewController = ReviewDetailAssembly.assemblyModule(input: reviewInput)
    let sheet = SheetViewController(
      controller: reviewDetailViewController,
      sizes: [.percent(0.5), .fullscreen],
      options: options)

    UIApplication.topViewController()?.present(sheet, animated: true, completion: nil)
  }

  func pushToReviewsViewController(wineID: Int64) {
    let controller = ReviewsAssembly.assemblyModule(input: .init(wineID: wineID))
    controller.hidesBottomBarWhenPushed = true
    UIApplication.topViewController()?.navigationController?.pushViewController(
      controller,
      animated: true)
  }

  func presentWineDetailViewController(wineID: Int64) {
    let controller = WineDetailAssembly.assemblyModule(input: .init(wineID: wineID), coordinator: Coordinator.shared)
    let navigationController = VinchyNavigationController(rootViewController: controller)
    navigationController.modalPresentationStyle = .overFullScreen
    UIApplication.topViewController()?.present(
      navigationController,
      animated: true,
      completion: nil)
  }

  func presentActivityViewController(items: [Any], sourceView: UIView) {
    let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
    if let popoverController = controller.popoverPresentationController {
      popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
      popoverController.sourceView = sourceView
    }
    UIApplication.topViewController()?.present(controller, animated: true)
  }

  func pushToWineDetailViewController(wineID: Int64) {
    if UIDevice.current.userInterfaceIdiom == .pad {
      presentWineDetailViewController(wineID: wineID)
    } else {
      let controller = WineDetailAssembly.assemblyModule(input: .init(wineID: wineID), coordinator: Coordinator.shared)
      controller.hidesBottomBarWhenPushed = true
      UIApplication.topViewController()?.navigationController?.pushViewController(
        controller,
        animated: true)
    }
  }

  func pushToStoreViewController(affilatedId: Int) { }

  func pushToStoresViewController(wineID: Int64) { }

  func presentWriteReviewViewController(
    reviewID: Int?,
    wineID: Int64,
    rating: Double,
    reviewText: String?) { }

  func pushToWriteViewController(note: VNote) { }

  func presentWriteViewController(note: VNote) { }

  func pushToWriteViewController(wine: Wine) { }

  func presentWriteViewController(wine: Wine) { }

  func pushToShowcaseViewController(input: ShowcaseInput) { }
}
