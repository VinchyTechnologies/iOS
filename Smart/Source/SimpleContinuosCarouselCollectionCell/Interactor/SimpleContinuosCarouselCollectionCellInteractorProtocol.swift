//
//  SimpleContinuosCarouselCollectionCellInteractorProtocol.swift
//  Smart
//
//  Created by Михаил Исаченко on 14.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import VinchyCore

protocol SimpleContinuosCarouselCollectionCellInteractorProtocol: AnyObject {
  func viewDidLoad()
  func didTapBottleCell(wineID: Int64)
  func didTapCompilationCell(wines: [ShortWine], title: String?)
  func didTapShareContextMenu(wineID: Int64)
  func didTapLeaveReviewContextMenu(wineID: Int64)
  func didTapWriteNoteContextMenu(wineID: Int64)
}
