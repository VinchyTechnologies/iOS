//
//  WineDetailViewModel.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI

struct WineDetailViewModel {

  enum ItemID: String, Hashable {
    case similarWines, ad, titleItem, similarWinesTitle, servingTipsTitle, whereToBuyTitle, winery, gallery, writeReviewButton, tool, rate, whereToBuy, list, noReviewsYet, expandCollapse
  }

  enum SectionID: Hashable {
    case similarWines, ad, title(ItemID), winery, gallery, button(ItemID), tool, rate, whereToBuy, list, text, expandCollapse
  }

  enum ShortInfoModel {
    case titleTextAndImage(imageName: String, titleText: String?)
    case titleTextAndSubtitleText(titleText: String?, subtitleText: String?)
  }

  enum Section {
    case gallery(itemID: ItemID, GalleryView.Content) // done
    case title(itemID: ItemID, Label.Content) // done
    case rate(itemID: ItemID, content: StarRatingControlView.Content) // done
    case winery(itemID: ItemID, Label.Content) // done
    case text(itemID: ItemID, Label.Content) // done
    case tool(itemID: ItemID, content: ToolView.Content) // done
    case list(itemID: ItemID, content: [TitleWithSubtitleInfoView.Content]) // done
    case ratingAndReview([RatingsAndReviewsCellViewModel])
    case reviews([ReviewCellViewModel])
    case servingTips([ShortInfoModel])
    case button(itemID: ItemID, content: ButtonView.Content) // done
    case ad(itemID: ItemID) // done
    case similarWines(itemID: ItemID, content: BottlesCollectionView.Content) // done
    case expandCollapse(itemID: ItemID, content: ExpandCollapseView.Content) // done
    case whereToBuy(itemID: ItemID, content: [WhereToBuyView.Content]) // done

    // MARK: Internal

    var dataID: SectionID {
      switch self {
      case .gallery:
        return .gallery

      case .title(let itemID, _):
        return .title(itemID)

      case .rate:
        return .rate

      case .winery:
        return .winery

      case .text:
        return .text

      case .tool:
        return .tool

      case .list:
        return .list

      case .ratingAndReview(_):
        return .similarWines

      case .reviews(_):
        return .similarWines
      case .servingTips(_):
        return .similarWines

      case .button(let itemID, _):
        return .button(itemID)

      case .ad:
        return .ad

      case .similarWines:
        return .similarWines

      case .expandCollapse:
        return .expandCollapse

      case .whereToBuy:
        return .whereToBuy
      }
    }
  }

  let navigationTitle: String?
  var sections: [Section]
  var isGeneralInfoCollapsed: Bool
}
