//
//  WineDetailPresenter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core
import DisplayMini
import StringFormatting
import UIKit.UIImage
import VinchyCore

// MARK: - C

private enum C {
  static let imageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .default)
  static let numberOfNonHiddenRowsInGeneralInfoSection: Int = 3
}

// MARK: - WineDetailPresenter

final class WineDetailPresenter {

  // MARK: Lifecycle

  init(input: WineDetailInput, viewController: WineDetailViewControllerProtocol) {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: WineDetailViewControllerProtocol?
  var viewModel: WineDetailViewModel?

  // MARK: Private

  private let viewModelFactory = WineDetailViewModelFactory()

  private let input: WineDetailInput

  private var contextMenuViewModels: [ContextMenuViewModel] {
    if input.isAppClip {
      return []
    } else {
      return [
        .share(content: .init(title: localized("share_link").firstLetterUppercased())),
        .writeNote(content: .init(title: localized("write_note").firstLetterUppercased())),
      ]
    }
  }

  private func generateAllSections(
    wine: Wine,
    reviews: [Review]?,
    isLiked: Bool,
    isDisliked: Bool,
    rating: Rating?,
    price: Int64,
    currency: String,
    isAccuratePrice: Bool,
    stores: [PartnerInfo]?,
    isGeneralInfoCollapsed: Bool) async
    -> [WineDetailViewModel.Section]
  {
    var sections: [WineDetailViewModel.Section] = []
    sections += await viewModelFactory.buildCaruselImages(wine: wine)
    sections += await viewModelFactory.buildWinery(wine: wine)
    sections += await viewModelFactory.buildTitle(wine: wine)
    sections += await viewModelFactory.buildStarRateControl(rating: rating)
    sections += await viewModelFactory.buildToolSection(
      price: price,
      currency: currency,
      isAccuratePrice: isAccuratePrice,
      isLiked: isLiked,
      isAppClip: input.isAppClip)

//    if isDescriptionInWineDetailEnabled {
//      sections += [
//        .text([.init(
//          titleText: NSAttributedString(
//            string: wine.desc ?? "",
//            font: Font.light(18),
//            textColor: .dark))]),
//      ]
//    }

    let generalInfoRows = await viewModelFactory.buildGeneralInfo(
      wine: wine,
      prefix: C.numberOfNonHiddenRowsInGeneralInfoSection)
    sections += generalInfoRows.sections

    if generalInfoRows.count > C.numberOfNonHiddenRowsInGeneralInfoSection {
      let titleText = isGeneralInfoCollapsed
        ? localized("expand").firstLetterUppercased()
        : localized("collapse").firstLetterUppercased()
      sections += [
        .expandCollapse(itemID: .expandCollapse, content: .init(chevronDirection: isGeneralInfoCollapsed ? .down : .up, titleText: titleText, animated: false)),
      ]
    }

    sections += await viewModelFactory.buildServingTips(wine: wine)

    if let reviews = reviews {
      sections += await viewModelFactory.buildReview(reviews: reviews)
      sections += [.button(itemID: .writeReviewButton, content: .init(buttonText: localized("write_review").firstLetterUppercased()))]
    }

    if !input.isAppClip {
      /// Ad
      sections += [.ad(itemID: .ad)]

      /// where to buy

      switch input.mode {
      case .normal:
        if let stores = stores, !stores.isEmpty {
          sections += [
            .ratingAndReview(
              itemID: .whereToBuyTitle,
              content: TitleAndMoreView.Content(
                titleText: localized("where_to_buy").firstLetterUppercased(),
                moreText: localized("see_all").firstLetterUppercased(),
                shouldShowMoreText: stores.count >= 5)),
          ]

          let storeViewModels: [WhereToBuyCellViewModel] = stores.compactMap { partner in
            .init(affilatedId: partner.affiliatedStoreId, imageURL: partner.logoURL, titleText: partner.title, subtitleText: nil)
          }

          sections += [
            .whereToBuy(itemID: .whereToBuy, content: storeViewModels),
          ]
        }

      case .partner:
        break
      }
    }

    if input.shouldShowSimilarWine {
      sections += await viewModelFactory.buildSimilarWines(
        wine: wine,
        contextMenuViewModels: contextMenuViewModels)
    }

    return sections
  }
}

// MARK: WineDetailPresenterProtocol

extension WineDetailPresenter: WineDetailPresenterProtocol {

  var reportAnErrorText: String? {
    localized("tell_about_error").firstLetterUppercased()
  }

  var dislikeText: String? {
    localized("unlike").firstLetterUppercased()
  }

  var reportAnErrorRecipients: [String] {
    [localized("contact_email")]
  }

  func setLikedStatus(isLiked: Bool) {
    viewModel?.isLiked = isLiked
    viewController?.updateLike(isLiked: isLiked)
  }

  func showAppClipDownloadFullApp() {
    viewController?.showAppClipDownloadFullApp()
  }

  func showReviewButtonTutorial() {
    viewController?.showReviewButtonTutorial(
      viewModel: .init(
        title: localized("leave_review_more_often").firstLetterUppercased(),
        content: localized("hint_to_review_button").firstLetterUppercased()))
  }

  func expandOrCollapseGeneralInfo(wine: Wine, isGeneralInfoCollapsed: Bool) async {

    let indexOfGeneralInfo = viewModel?.sections.firstIndex(where: { section in
      switch section {
      case .list:
        return true

      default:
        return false
      }
    })

    guard let indexOfGeneralInfo = indexOfGeneralInfo else {
      return
    }

    guard
      let section = await viewModelFactory.buildGeneralInfo(
        wine: wine,
        prefix: isGeneralInfoCollapsed ? C.numberOfNonHiddenRowsInGeneralInfoSection : nil).sections.first
    else {
      return
    }

    viewModel?.sections[indexOfGeneralInfo] = section

    let indexOfExpandCollapse = viewModel?.sections.firstIndex(where: { section in
      switch section {
      case .expandCollapse:
        return true

      default:
        return false
      }
    })

    if let indexOfExpandCollapse = indexOfExpandCollapse {
      let titleText = isGeneralInfoCollapsed
        ? localized("expand").firstLetterUppercased()
        : localized("collapse").firstLetterUppercased()

      viewModel?.sections[indexOfExpandCollapse] = .expandCollapse(itemID: .expandCollapse, content: .init(chevronDirection: isGeneralInfoCollapsed ? .down : .up, titleText: titleText, animated: false))
    }

    guard var viewModel = viewModel else {
      return
    }

    viewModel.isGeneralInfoCollapsed = isGeneralInfoCollapsed

    viewController?.updateGeneralInfoSectionAndExpandOrCollapseCell(viewModel: viewModel)

    self.viewModel = viewModel
  }

  func scrollToWhereToBuySections() {
    viewController?.scrollToWhereToBuySections(
      itemDataID: WineDetailViewModel.ItemID.whereToBuyTitle,
      dataID: WineDetailViewModel.SectionID.ratingAndReview)
  }

  func showAlertWineAlreadyDisliked() {
    viewController?.showAlert(title: localized("error").firstLetterUppercased(), message: localized("you_have_already_disliked_the_wine"))
  }

  func showAlertWineAlreadyLiked() {
    viewController?.showAlert(title: localized("error").firstLetterUppercased(), message: localized("you_have_already_liked_the_wine"))
  }

  func showNetworkErrorAlert(error: Error) {
    viewController?.showAlert(title: localized("error").firstLetterUppercased(), message: error.localizedDescription)
  }

  func showAlertCantOpenEmail() {
    viewController?.showAlert(title: localized("error").firstLetterUppercased(), message: localized("open_mail_error"))
  }

  func startLoading() {
    viewController?.addLoader()
    viewController?.startLoadingAnimation()
  }

  func stopLoading() {
    viewController?.stopLoadingAnimation()
  }

  func update(
    wine: Wine,
    reviews: [Review]?,
    isLiked: Bool,
    isDisliked: Bool,
    rating: Rating?,
    price: Int64,
    currency: String,
    isAccuratePrice: Bool,
    stores: [PartnerInfo]?,
    isGeneralInfoCollapsed: Bool) async
  {

    let sections = await generateAllSections(
      wine: wine,
      reviews: reviews,
      isLiked: isLiked,
      isDisliked: isDisliked,
      rating: rating,
      price: price,
      currency: currency,
      isAccuratePrice: isAccuratePrice,
      stores: stores,
      isGeneralInfoCollapsed: isGeneralInfoCollapsed)

    let viewModel = WineDetailViewModel(
      navigationTitle: wine.title,
      sections: sections,
      isGeneralInfoCollapsed: isGeneralInfoCollapsed,
      bottomPriceBarViewModel: .init(
        leadingText: localized("price").firstLetterUppercased(),
        trailingButtonText: "~" + formatCurrencyAmount(
          wine.price ?? 0, currency: currency)),
      isLiked: isLiked)

    DispatchQueue.main.async {
      self.viewController?.updateUI(viewModel: viewModel)
    }

    self.viewModel = viewModel
  }

  func showStatusAlertDidLikedSuccessfully() {
    viewController?.showStatusAlert(
      viewModel: .init(
        image: UIImage(systemName: "heart"),
        titleText: localized("loved").firstLetterUppercased(),
        descriptionText: localized("will_recommend_more").firstLetterUppercased()))
  }

  func showStatusAlertDidDislikedSuccessfully() {
    viewController?.showStatusAlert(
      viewModel: .init(
        image: UIImage(systemName: "heart.slash"),
        titleText: localized("unloved").firstLetterUppercased(),
        descriptionText: localized("will_recommend_less").firstLetterUppercased()))
  }
}
