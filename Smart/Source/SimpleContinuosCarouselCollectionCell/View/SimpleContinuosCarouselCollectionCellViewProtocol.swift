//
//  SimpleContinuosCarouselCollectionCellViewControllerProtocol.swift
//  Smart
//
//  Created by Михаил Исаченко on 14.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display

protocol SimpleContinuosCarouselCollectionCellViewProtocol: Loadable {
  func updateUI(viewModel: SimpleContinuousCaruselCollectionCellViewModel)
  func showAlert(title: String, message: String)
}
