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
}

// MARK: - WineDetailPresenter

final class WineDetailPresenter {

  // MARK: Lifecycle

  init(viewController: WineDetailViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: WineDetailViewControllerProtocol?

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

  private func buildGeneralInfo(wine: Wine) -> [WineDetailViewModel.Section] {
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

    if !shortDescriptions.isEmpty {
      return [.list(shortDescriptions)]
    } else {
      return []
    }
  }

  private func buildServingTips(wine: Wine) -> [WineDetailViewModel.Section] {
    var servingTips = [WineDetailViewModel.ShortInfoModel]()

    if let servingTemperature = localizedTemperature(wine.servingTemperature) {
      servingTips.append(.titleTextAndSubtitleText(titleText: servingTemperature, subtitleText: localized("serving_temperature").firstLetterUppercased()))
    }

    if let dishes = wine.dishCompatibility, !dishes.isEmpty {
      dishes.forEach { dish in
        servingTips.append(.titleTextAndImage(imageName: dish.imageName, titleText: localized(dish.rawValue).firstLetterUppercased()))
      }
    }

    if !servingTips.isEmpty {
      return [
        .title([.init(
          titleText: NSAttributedString(
            string: localized("serving_tips").firstLetterUppercased(),
            font: Font.heavy(20),
            textColor: .dark))]),
        .servingTips(servingTips),
      ]
    } else {
      return []
    }
  }

  private func buildReview(wine: Wine) -> [WineDetailViewModel.Section] {
    let reviewCellViewModels: [ReviewCellViewModel] = wine.reviews.compactMap {
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
      return []
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

  func update(wine: Wine, isLiked: Bool, isDisliked _: Bool, rate _: Double, currency: String) {
    var sections: [WineDetailViewModel.Section] = []

    sections += buildCaruselImages(wine: wine)

    if let wineryTitle = wine.winery?.title {
      sections += [
        .winery([
          .init(titleText: NSAttributedString(
            string: wineryTitle,
            font: Font.medium(18),
            textColor: .blueGray)),
        ]),
      ]
    }

    sections += [
      .title([.init(
        titleText: NSAttributedString(
          string: wine.title,
          font: Font.heavy(20),
          textColor: .dark))]),
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

    sections += buildGeneralInfo(wine: wine)

    if isReviewAvailable {
//      sections += [.tapToRate([.init(titleText: "Tap to Rate:", rate: 0)])]
      sections += buildReview(wine: wine)
      sections += [.button([.init(buttonText: localized("write_review").firstLetterUppercased())])]
    }

    if isAdAvailable {
      sections += [.ad([1])] // TODO: - Add Real Model
    }

    var wineList: [CollectionItem] = []

    if let similarWines = wine.similarWines {
      similarWines.forEach { shortWine in
        wineList.append(.wine(wine: shortWine))
      }
      let collections: [Collection] = [Collection(wineList: wineList)]

      sections += [.title([.init(titleText: NSAttributedString(string: localized("similar_wines").firstLetterUppercased(), font: Font.heavy(20), textColor: .dark))])]

      sections += [.similarWines([VinchySimpleConiniousCaruselCollectionCellViewModel(type: .bottles, collections: collections)])]
    }

    viewController?.updateUI(viewModel: WineDetailViewModel(navigationTitle: wine.title, sections: sections))
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
