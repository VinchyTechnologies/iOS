//
//  SimpleContinuosCarouselCollectionCellPresenter.swift
//  Smart
//
//  Created by Михаил Исаченко on 14.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import StringFormatting

// MARK: - SimpleContinuosCarouselCollectionCellPresenter

final class SimpleContinuosCarouselCollectionCellPresenter {

  // MARK: Lifecycle

  init(view: SimpleContinuosCarouselCollectionCellViewProtocol) {
    self.view = view
  }

  // MARK: Internal

  weak var view: SimpleContinuosCarouselCollectionCellViewProtocol?

  // MARK: Private

  private typealias ViewModel = SimpleContinuousCaruselCollectionCellViewModel
}

// MARK: SimpleContinuosCarouselCollectionCellPresenterProtocol

extension SimpleContinuosCarouselCollectionCellPresenter: SimpleContinuosCarouselCollectionCellPresenterProtocol {
  func update(model: SimpleContinuousCaruselCollectionCellViewModel) {
    view?.updateUI(viewModel: model)
  }

  func showNetworkErrorAlert(error: Error) {
    view?.showAlert(title: localized("error").firstLetterUppercased(), message: error.localizedDescription)
  }

  func startLoading() {
    view?.addLoader()
    view?.startLoadingAnimation()
  }

  func stopLoading() {
    view?.stopLoadingAnimation()
  }

  func showAlertEmptyCollection() {
    view?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: localized("empty_collection"))
  }
}
