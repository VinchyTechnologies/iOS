//
//  WineDetailInteractorProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit // TODO: - delete UIKit

protocol WineDetailInteractorProtocol: AnyObject {
  func viewDidLoad()
  func didTapLikeButton(_ button: UIButton)
  func didTapDislikeButton()
  func didTapShareButton()
  func didTapNotes()
  func didTapMore(_ button: UIButton)
  func didTapPriceButton()
  func didTapReportAnError()
  func didTapSimilarWine(wineID: Int64)
}
