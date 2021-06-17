//
//  WineDetailViewModel.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI

struct WineDetailViewModel {
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
    case similarWines([VinchySimpleConiniousCaruselCollectionCellViewModel])
  }

  let navigationTitle: String?
  var sections: [Section]
}
