//
//  WineDetailPresenter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Core
import Display
import StringFormatting
import VinchyCore

// MARK: - C

private enum C {
  static let imageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .default)
  static let numberOfNonHiddenRowsInGeneralInfoSection: Int = 3
}

// MARK: - WineDetailPresenter

final class WineDetailPresenter {

  // MARK: Lifecycle

  init(viewController: WineDetailViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: WineDetailViewControllerProtocol?

  var viewModel: WineDetailViewModel?

  // MARK: Private

  // TODO: - Make Factory Pattern

  private func buildCaruselImages(wine: Wine) -> [WineDetailViewModel.Section] {
    let arg1 = [String(wine.mainImageUrl ?? "")]
    let arg2 = [String(wine.labelImageUrl ?? "")]
    let imageURLs: [String?] = (arg1 + arg2 + Array(wine.imageURLs ?? [])).map { str -> String? in
      str == "" ? nil : str
    }

    if !imageURLs.isEmpty {
      return [.gallery([.init(urls: imageURLs)])]
    } else {
      return []
    }
  }

  private func buildGeneralInfo(wine: Wine, prefix: Int?) -> (sections: [WineDetailViewModel.Section], count: Int) {
    var shortDescriptions: [TitleWithSubtitleInfoCollectionViewCellViewModel] = []

    if let color = wine.color {
      shortDescriptions.append(.init(titleText: localized(color.rawValue).firstLetterUppercased(), subtitleText: localized("color").firstLetterUppercased()))
    }

    if let sugar = wine.sugar {
      shortDescriptions.append(.init(titleText: localized(sugar.rawValue).firstLetterUppercased(), subtitleText: localized("sugar").firstLetterUppercased()))
    }

    if let country = countryNameFromLocaleCode(countryCode: wine.winery?.countryCode) {
      shortDescriptions.append(.init(titleText: country, subtitleText: localized("country").firstLetterUppercased()))
    }

    if let year = wine.year, year != 0 {
      shortDescriptions.append(.init(titleText: String(year), subtitleText: localized("vintage").firstLetterUppercased()))
    }

    if let alcoholPercent = wine.alcoholPercent {
      shortDescriptions.append(.init(titleText: String(alcoholPercent) + "%", subtitleText: localized("alcohol").firstLetterUppercased()))
    }

    if let region = wine.winery?.region {
      shortDescriptions.append(.init(titleText: region, subtitleText: localized("region").firstLetterUppercased()))
    }

    if let grapes = wine.grapes, !grapes.isEmpty {
      let grapesString = grapes.joined(separator: ", ")
      shortDescriptions.append(
        .init(
          titleText: grapesString,
          subtitleText: localizedPlural(
            "sortsOfGrape",
            count: UInt(grapes.count)).firstLetterUppercased()))
    }

    if !shortDescriptions.isEmpty {
      if let prefix = prefix {
        return (sections: [.list(Array(shortDescriptions.prefix(prefix)))], count: shortDescriptions.count)
      } else {
        return (sections: [.list(shortDescriptions)], count: shortDescriptions.count)
      }
    } else {
      return (sections: [], count: 0)
    }
  }

  private func buildServingTips(wine: Wine) -> [WineDetailViewModel.Section] {
    var servingTips = [WineDetailViewModel.ShortInfoModel]()

    if let servingTemperature = localizedTemperature(wine.minServingTemperature, wine.maxServingTemperature) {
      servingTips.append(.titleTextAndSubtitleText(titleText: servingTemperature, subtitleText: localized("serving_temperature").firstLetterUppercased()))
    }

    if let dishes = wine.dishCompatibility, !dishes.isEmpty {
      dishes.forEach { dish in
        servingTips.append(.titleTextAndImage(imageName: dish.imageName, titleText: dish.localized))
      }
    }

    if !servingTips.isEmpty {
      return [
        .title(itemID: .servingTipsTitle, localized("serving_tips").firstLetterUppercased()),
//        .title([.init(
//          titleText: NSAttributedString(
//            string: localized("serving_tips").firstLetterUppercased(),
//            font: Font.heavy(20),
//            textColor: .dark))]),
        .servingTips(servingTips),
      ]
    } else {
      return []
    }
  }

  private func buildReview(reviews: [Review]) -> [WineDetailViewModel.Section] {
    let reviewCellViewModels: [ReviewCellViewModel] = reviews.compactMap {
      if $0.comment?.isEmpty == true || $0.comment == nil {
        return nil
      }

      let dateText: String?

      if $0.updateDate == nil {
        dateText = $0.publicationDate.toDate()
      } else {
        dateText = $0.updateDate.toDate()
      }

      return ReviewCellViewModel(
        id: $0.id,
        userNameText: nil,
        dateText: dateText,
        reviewText: $0.comment,
        rate: $0.rating)
    }

    if reviewCellViewModels.isEmpty {
      return [
        .ratingAndReview([
          .init(
            titleText: localized("reviews").firstLetterUppercased(),
            moreText: localized("see_all").firstLetterUppercased(),
            shouldShowMoreText: reviewCellViewModels.count >= 5),
        ]),

        .text([
          .init(
            titleText: NSAttributedString(
              string: localized("wine_has_no_reviews_yet").firstLetterUppercased(),
              font: Font.semibold(16),
              textColor: .dark,
              paragraphAlignment: .center)),
        ]),
      ]
    }

    return [
      .ratingAndReview([
        .init(
          titleText: localized("reviews").firstLetterUppercased(),
          moreText: localized("see_all").firstLetterUppercased(),
          shouldShowMoreText: reviewCellViewModels.count >= 5),
      ]),
      .reviews(reviewCellViewModels),
    ]
  }

  private func buildStarRateControl(rate: Double) -> [WineDetailViewModel.Section] {
    let rateViewModel = StarRatingControlCollectionViewCellViewModel(rate: rate)
    return [.rate([rateViewModel])]
  }

  private func generateAllSections(wine: Wine, reviews: [Review]?, isLiked: Bool, isDisliked: Bool, rate: Double, currency: String, stores: [PartnerInfo]?, isGeneralInfoCollapsed: Bool) -> [WineDetailViewModel.Section] {
    var sections: [WineDetailViewModel.Section] = []

    sections += buildCaruselImages(wine: wine)


    /// Winery

    if let wineryTitle = wine.winery?.title {
      sections += [
        .winery(
          itemID: .winery, wineryTitle
//          .init(titleText: NSAttributedString(
//            string: wineryTitle,
//            font: Font.medium(18),
//            textColor: .blueGray)),
        ),
      ]
    }

    sections += [
      .title(itemID: .titleItem, wine.title),
//      .title([.init(
//        titleText: NSAttributedString(
//          string: wine.title,
//          font: Font.heavy(20),
//          textColor: .dark))]),
    ]

    if isReviewAvailable {
      if let rating = wine.rating {
        sections += buildStarRateControl(rate: rating)
      } else {
        sections += buildStarRateControl(rate: 0.0)
      }
    }

    sections += [
      .tool([.init(
        price: formatCurrencyAmount(
          wine.price ?? 0, currency: currency),
        isLiked: isLiked)]),
    ]

    if isDescriptionInWineDetailEnabled {
      sections += [
        .text([.init(
          titleText: NSAttributedString(
            string: wine.desc ?? "",
            font: Font.light(18),
            textColor: .dark))]),
      ]
    }

    let generalInfoRows = buildGeneralInfo(wine: wine, prefix: C.numberOfNonHiddenRowsInGeneralInfoSection)
    sections += generalInfoRows.sections

    if generalInfoRows.count > C.numberOfNonHiddenRowsInGeneralInfoSection {
      let titleText = isGeneralInfoCollapsed
        ? localized("expand").firstLetterUppercased()
        : localized("collapse").firstLetterUppercased()
      sections += [.expandCollapse([.init(chevronDirection: .down, titleText: titleText, animated: false)])]
    }

    sections += buildServingTips(wine: wine)

    if isReviewAvailable {
//      sections += [.tapToRate([.init(titleText: "Tap to Rate:", rate: 0)])]
      if let reviews = reviews {
        sections += buildReview(reviews: reviews)
        sections += [.button([.init(buttonText: localized("write_review").firstLetterUppercased())])]
      }
    }

    /// Ad

    if isAdAvailable {
      sections += [.ad(itemID: .ad)]
    }

    /// where to buy

    if let stores = stores, !stores.isEmpty {
      sections += [
        .title(itemID: .whereToBuyTitle, localized("where_to_buy").firstLetterUppercased()),
//        .title([.init(
//          titleText: NSAttributedString(
//            string: localized("where_to_buy").firstLetterUppercased(),
//            font: Font.heavy(20),
//            textColor: .dark))]),
      ]

      let storeViewModels: [WhereToBuyCellViewModel] = stores.compactMap { partner in
        .init(affilatedId: partner.affiliatedStoreId, imageURL: partner.logoURL, titleText: partner.title, subtitleText: nil)
      }

      sections += [
        .whereToBuy(storeViewModels),
      ]
    }

    /// Similar wines

    if let similarWines = wine.similarWines {

      var wineList: [WineBottleView.Content] = []

      similarWines.forEach { shortWine in
        wineList.append(
          .init(
            wineID: shortWine.id,
            imageURL: shortWine.mainImageUrl?.toURL,
            titleText: shortWine.title,
            subtitleText: countryNameFromLocaleCode(countryCode: shortWine.winery?.countryCode)))
      }

      sections += [
        .title(itemID: .similarWinesTitle, localized("similar_wines").firstLetterUppercased()),
//        .title([.init(titleText: NSAttributedString(string: localized("similar_wines").firstLetterUppercased(), font: Font.heavy(20), textColor: .dark))])
      ]

      sections += [.similarWines(itemID: .similarWines, content: wineList)]
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

  func showReviewButtonTutorial() {
    viewController?.showReviewButtonTutorial(
      viewModel: .init(
        title: localized("leave_review_more_often").firstLetterUppercased(),
        content: localized("hint_to_review_button").firstLetterUppercased()))
  }

  func expandOrCollapseGeneralInfo(wine: Wine, isGeneralInfoCollapsed: Bool) {

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
      let section = buildGeneralInfo(
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

      viewModel?.sections[indexOfExpandCollapse] = .expandCollapse([.init(chevronDirection: isGeneralInfoCollapsed ? .down : .up, titleText: titleText, animated: false)])
    }

    guard var viewModel = viewModel else {
      return
    }

    viewModel.isGeneralInfoCollapsed = isGeneralInfoCollapsed

    viewController?.updateGeneralInfoSectionAndExpandOrCollapseCell(viewModel: viewModel)

    self.viewModel = viewModel
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

  func update(wine: Wine, reviews: [Review]?, isLiked: Bool, isDisliked: Bool, rate: Double, currency: String, stores: [PartnerInfo]?, isGeneralInfoCollapsed: Bool) {

    let sections = generateAllSections(wine: wine, reviews: reviews, isLiked: isLiked, isDisliked: isDisliked, rate: rate, currency: currency, stores: stores, isGeneralInfoCollapsed: isGeneralInfoCollapsed)

    let viewModel = WineDetailViewModel(navigationTitle: wine.title, sections: sections, isGeneralInfoCollapsed: isGeneralInfoCollapsed)

    viewController?.updateUI(viewModel: viewModel)

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
