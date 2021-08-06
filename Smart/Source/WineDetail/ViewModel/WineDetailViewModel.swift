//
//  WineDetailViewModel.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI

struct WineDetailViewModel {

  enum ItemID: String {
    case similarWines
  }

  enum SectionID {
    case similarWines
  }

  enum ShortInfoModel {
    case titleTextAndImage(imageName: String, titleText: String?)
    case titleTextAndSubtitleText(titleText: String?, subtitleText: String?)
  }

  enum Section {
    case gallery([GalleryCellViewModel])
    case title([TitleCopyableCellViewModel])
    case rate([StarRatingControlCollectionViewCellViewModel])
    case winery([TextCollectionCellViewModel])
    case text([TextCollectionCellViewModel])
    case tool([ToolCollectionCellViewModel])
    case list([TitleWithSubtitleInfoCollectionViewCellViewModel])
    case ratingAndReview([RatingsAndReviewsCellViewModel])
    case tapToRate([TapToRateCellViewModel])
    case reviews([ReviewCellViewModel])
    case servingTips([ShortInfoModel])
    case button([ButtonCollectionCellViewModel])
    case ad([Any]) // TODO: - Not Any
    case similarWines(itemID: ItemID, content: BottlesCollectionView.Content) // done
    case expandCollapse([ExpandCollapseCellViewModel])
    case whereToBuy([WhereToBuyCellViewModel])

    // MARK: Internal

    var dataID: SectionID {
      switch self {
      case .gallery(_):
        return .similarWines
      case .title(_):
        return .similarWines
      case .rate(_):
        return .similarWines
      case .winery(_):
        return .similarWines
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
      case .ad(_):
        return .similarWines

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
