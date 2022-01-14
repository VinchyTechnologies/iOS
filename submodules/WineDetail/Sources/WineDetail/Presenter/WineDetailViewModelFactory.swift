//
//  WineDetailViewModelFactory.swift
//  WineDetail
//
//  Created by Алексей Смирнов on 10.01.2022.
//

import DisplayMini
import StringFormatting
import UIKit
import VinchyCore

final class WineDetailViewModelFactory {

  func buildCaruselImages(wine: Wine) async -> [WineDetailViewModel.Section] {
    let arg1 = [String(wine.mainImageUrl ?? "")]
    let arg2 = [String(wine.labelImageUrl ?? "")]
    let imageURLs: [String?] = (arg1 + arg2 + Array(wine.imageURLs ?? [])).map { str -> String? in
      str == "" ? nil : str
    }

    if !imageURLs.isEmpty {
      return [.gallery(itemID: .gallery, .init(urls: imageURLs))]
    } else {
      return []
    }
  }

  func buildWinery(wine: Wine) async -> [WineDetailViewModel.Section] {
    if let wineryTitle = wine.winery?.title {
      return [
        .winery(itemID: .winery, wineryTitle),
      ]
    }
    return []
  }

  func buildTitle(wine: Wine) async -> [WineDetailViewModel.Section] {
    [.name(itemID: .name, wine.title)]
  }

  func buildStarRateControl(rating: Rating?) async -> [WineDetailViewModel.Section] {
    let rateViewModel = StarRatingControlCollectionViewCellViewModel(
      rate: rating?.rating ?? 0,
      count: rating?.reviewsCount ?? 0)
    return [.rate(itemID: .rate, content: rateViewModel)]
  }

  func buildToolSection(wine: Wine, currency: String, isLiked: Bool, isAppClip: Bool) async -> [WineDetailViewModel.Section] {
    if !isAppClip {
      return [
        .tool(
          itemID: .tool,
          content: .init(
            price: formatCurrencyAmount(
              wine.price ?? 0, currency: currency),
            isLiked: isLiked,
            isAppClip: isAppClip)),
      ]
    }
    return []
  }

  func buildGeneralInfo(wine: Wine, prefix: Int?) async -> (sections: [WineDetailViewModel.Section], count: Int) {
    var shortDescriptions: [TitleWithSubtitleInfoCollectionViewCellViewModel] = []

    if let color = wine.color {
      shortDescriptions.append(.init(titleText: localized(color.rawValue).firstLetterUppercased(), subtitleText: localized("color").firstLetterUppercased()))
    }

    if let sugar = wine.sugar {
      shortDescriptions.append(.init(titleText: localized(sugar.rawValue).firstLetterUppercased(), subtitleText: localized("sugar").firstLetterUppercased()))
    }

    if let countryCode = wine.winery?.countryCode, let country = countryNameFromLocaleCode(countryCode: countryCode) {
      let flag = emojiFlagForISOCountryCode(countryCode).isEmpty
        ? ""
        : emojiFlagForISOCountryCode(countryCode) + " "
      shortDescriptions.append(.init(titleText: flag + country, subtitleText: localized("country").firstLetterUppercased()))
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
        return (sections: [.list(itemID: .list, content: Array(shortDescriptions.prefix(prefix)))], count: shortDescriptions.count)
      } else {
        return (sections: [.list(itemID: .list, content: shortDescriptions)], count: shortDescriptions.count)
      }
    } else {
      return (sections: [], count: 0)
    }
  }

  func buildServingTips(wine: Wine) async -> [WineDetailViewModel.Section] {
    var servingTips = [ServingTipsCollectionViewItem]()

    if let servingTemperature = localizedTemperature(wine.minServingTemperature, wine.maxServingTemperature) {
      let subtitle = localized("serving_temperature").firstLetterUppercased()
      servingTips.append(.titleOption(content: .init(titleText: servingTemperature, subtitleText: subtitle)))
    }

    if let dishes = wine.dishCompatibility, !dishes.isEmpty {
      dishes.forEach { dish in
        servingTips.append(.imageOption(content: .init(image: UIImage(named: dish.imageName)?.withTintColor(.dark), titleText: dish.localized, isSelected: false)))
      }
    }

    if !servingTips.isEmpty {
      return [
        .title(itemID: .servingTipsTitle, localized("serving_tips").firstLetterUppercased()),
        .servingTips(itemID: .servingTips, content: .init(items: servingTips)),
      ]
    } else {
      return []
    }
  }

  func buildReview(reviews: [Review]) async -> [WineDetailViewModel.Section] {
    let reviewCellViewModels: [ReviewView.Content] = reviews.compactMap {
      if $0.comment?.isEmpty == true || $0.comment == nil {
        return nil
      }

      let dateText: String?

      if $0.updateDate == nil {
        dateText = $0.publicationDate.toDate()
      } else {
        dateText = $0.updateDate.toDate()
      }

      var contextMenuViewModels: [ReviewViewContextMenuViewModel] = []

      if let comment = $0.comment, canTranslateText(text: comment, showTranslate: true, ignoredLanguages: nil) {
        contextMenuViewModels.append(.translate(content: .init(title: "Translate")))
      }

      return ReviewView.Content(
        id: $0.id,
        userNameText: nil,
        dateText: dateText,
        reviewText: $0.comment,
        rate: $0.rating,
        contextMenuViewModels: contextMenuViewModels)
    }

    if reviewCellViewModels.isEmpty {
      return [
        .ratingAndReview(
          itemID: .titleReviews,
          content: .init(
            titleText: localized("reviews").firstLetterUppercased(),
            moreText: localized("see_all").firstLetterUppercased(),
            shouldShowMoreText: reviewCellViewModels.count >= 5)),

        .text(itemID: .noReviewsYet, localized("wine_has_no_reviews_yet").firstLetterUppercased()),
      ]
    }

    return [
      .ratingAndReview(
        itemID: .titleReviews,
        content: .init(
          titleText: localized("reviews").firstLetterUppercased(),
          moreText: localized("see_all").firstLetterUppercased(),
          shouldShowMoreText: reviewCellViewModels.count >= 5)),
      .reviews(itemID: .reviews, content: reviewCellViewModels),
    ]
  }

  func buildSimilarWines(wine: Wine, contextMenuViewModels: [ContextMenuViewModel]) async -> [WineDetailViewModel.Section] {
    if let similarWines = wine.similarWines {

      var sections: [WineDetailViewModel.Section] = []

      var wineList: [WineBottleView.Content] = []

      similarWines.forEach { shortWine in
        wineList.append(
          .init(
            wineID: shortWine.id,
            imageURL: shortWine.mainImageUrl?.toURL,
            titleText: shortWine.title,
            subtitleText: countryNameFromLocaleCode(countryCode: shortWine.winery?.countryCode),
            rating: shortWine.rating,
            buttonText: nil,
            contextMenuViewModels: contextMenuViewModels))
      }

      sections += [
        .title(itemID: .similarWinesTitle, localized("similar_wines").firstLetterUppercased()),
      ]

      sections += [.similarWines(itemID: .similarWines, content: wineList)]
      return sections
    }

    return []
  }

}
