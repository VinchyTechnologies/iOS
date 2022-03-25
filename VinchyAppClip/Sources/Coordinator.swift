//
//  Coordinator.swift
//  VinchyAppClip
//
//  Created by Алексей Смирнов on 04.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import AdvancedSearch
import Database
import DisplayMini
import UIKit
import VinchyCore
import VinchyUI
import WineDetail

final class Coordinator: WineDetailRoutable, ActivityRoutable, WriteNoteRoutable, AdvancedSearchRoutable, ResultsSearchRoutable, ReviewDetailRoutable, ReviewsRoutable, StoreRoutable, StoresRoutable, WriteReviewRoutable, ShowcaseRoutable, AuthorizationRoutable, WineShareRoutable, StatusAlertable, SafariRoutable, StoreShareRoutable, CartRoutable, QuestionsRoutable, QRRoutable {

  static let shared = Coordinator()

  func presentQuestiosViewController(affilatedId: Int, questions: [Question], currencyCode: String, questionsNavigationControllerDelegate: QuestionsNavigationControllerDelegate?) {

  }

  func presentQRViewController(affilatedId: Int, wineID: Int64) {

  }

  func presentCartViewController(affilatedId: Int) {
  }

  func presentAuthorizationViewController() { }

  func presentAdvancedSearch(preselectedFilters: [(String, String)], isPriceFilterAvailable: Bool, currencyCode: String?, affiliedId: Int, delegate: AdvancedSearchOutputDelegate?) {
    let controller = FiltersAssembly.assemblyModule(input: .init(preselectedFilters: preselectedFilters, isPriceFilterAvailable: isPriceFilterAvailable, currencyCode: currencyCode, affiliedId: affiliedId))
    let navController = AdvancedSearchNavigationController(rootViewController: controller)
    navController.advancedSearchOutputDelegate = delegate
    UIApplication.topViewController()?.present(navController, animated: true, completion: nil)
  }

  func pushToResultsSearchController(affilatedId: Int, currencyCode: String?, resultsSearchDelegate: ResultsSearchDelegate?) {
    let controller = ResultsSearchAssembly.assemblyModule(
      input: .init(mode: .storeDetail(affilatedId: affilatedId, currencyCode: currencyCode)), resultsSearchDelegate: resultsSearchDelegate)
    let navController = VinchyNavigationController(rootViewController: controller)
    navController.modalPresentationStyle = .overCurrentContext
    UIApplication.topViewController()?.present(navController, animated: true, completion: nil)
  }

  func showBottomSheetReviewDetailViewController(reviewInput: ReviewDetailInput) {
    let reviewDetailViewController = ReviewDetailAssembly.assemblyModule(input: reviewInput)
    UIApplication.topViewController()?.present(reviewDetailViewController, animated: true, completion: nil)
  }

  func pushToReviewsViewController(wineID: Int64) {
    let controller = ReviewsAssembly.assemblyModule(input: .init(wineID: wineID), coordinator: Coordinator.shared)
    controller.hidesBottomBarWhenPushed = true
    UIApplication.topViewController()?.navigationController?.pushViewController(
      controller,
      animated: true)
  }

  func presentWineDetailViewController(wineID: Int64, mode: WineDetailMode, shouldShowSimilarWine: Bool) {
    let controller = WineDetailAssembly.assemblyModule(input: .init(wineID: wineID, mode: mode, isAppClip: true, shouldShowSimilarWine: false), coordinator: Coordinator.shared, adGenerator: nil)
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

  func pushToWineDetailViewController(wineID: Int64, mode: WineDetailMode, shouldShowSimilarWine: Bool) {
    if UIDevice.current.userInterfaceIdiom == .pad {
      presentWineDetailViewController(wineID: wineID, mode: mode, shouldShowSimilarWine: shouldShowSimilarWine)
    } else {
      let controller = WineDetailAssembly.assemblyModule(input: .init(wineID: wineID, mode: mode, isAppClip: true, shouldShowSimilarWine: shouldShowSimilarWine), coordinator: Coordinator.shared, adGenerator: nil)
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

  func presentWriteViewController(note: VNote) { }

  func presentWriteViewController(wine: Wine) { }

  func pushToShowcaseViewController(input: ShowcaseInput) { }

  func didTapShare(type: WineShareType) { }

  func showStatusAlert(viewModel: StatusAlertViewModel) { }

  func didTapShareStore(type: StoreShareType) { }
}
