//
//  WineDetailViewModel.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI

struct WineDetailViewModel {

  enum ItemID: Hashable {
    case similarWines, ad, titleItem, similarWinesTitle, servingTipsTitle, whereToBuyTitle, winery
  }

  enum SectionID: Hashable {
    case similarWines, ad, title(ItemID), winery
  }

  enum ShortInfoModel {
    case titleTextAndImage(imageName: String, titleText: String?)
    case titleTextAndSubtitleText(titleText: String?, subtitleText: String?)
  }

  enum Section {
    case gallery([GalleryCellViewModel])
    case title(itemID: ItemID, Label.Content) // done
    case rate([StarRatingControlCollectionViewCellViewModel])
    case winery(itemID: ItemID, Label.Content)
    case text([TextCollectionCellViewModel])
    case tool([ToolCollectionCellViewModel])
    case list([TitleWithSubtitleInfoCollectionViewCellViewModel])
    case ratingAndReview([RatingsAndReviewsCellViewModel])
    case tapToRate([TapToRateCellViewModel])
    case reviews([ReviewCellViewModel])
    case servingTips([ShortInfoModel])
    case button([ButtonCollectionCellViewModel])
    case ad(itemID: ItemID) // done
    case similarWines(itemID: ItemID, content: BottlesCollectionView.Content) // done
    case expandCollapse([ExpandCollapseCellViewModel])
    case whereToBuy([WhereToBuyCellViewModel])

    // MARK: Internal

    var dataID: SectionID {
      switch self {
      case .gallery(_):
        return .similarWines

      case .title(let itemID, _):
        return .title(itemID)

      case .rate(_):
        return .similarWines

      case .winery:
        return .winery

      case .text(_):
        return .similarWines
      case .tool(_):
        return .similarWines
      case .list(_):
        return .similarWines
      case .ratingAndReview(_):
        return .similarWines
      case .tapToRate(_):
        return .similarWines
      case .reviews(_):
        return .similarWines
      case .servingTips(_):
        return .similarWines
      case .button(_):
        return .similarWines

      case .ad:
        return .ad

      case .similarWines:
        return .similarWines

      case .expandCollapse(_):
        return .similarWines
      case .whereToBuy(_):
        return .similarWines
      }
    }
  }

  let navigationTitle: String?
  var sections: [Section]
  var isGeneralInfoCollapsed: Bool
}
