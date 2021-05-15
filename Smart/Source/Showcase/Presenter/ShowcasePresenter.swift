//
//  ShowcasePresenter.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/11/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import StringFormatting
import VinchyCore

final class ShowcasePresenter {
  
  // MARK: - Internal Properties
  
  private var input: ShowcaseInput
  private weak var viewController: ShowcaseViewControllerProtocol?
  
  // MARK: - Initializers
  
  init(input: ShowcaseInput, viewController: ShowcaseViewControllerProtocol) {
    self.input = input
    self.viewController = viewController
  }
}

extension ShowcasePresenter: ShowcasePresenterProtocol {
  
  func startLoading() {
    viewController?.startLoadingAnimation()
    viewController?.addLoader()
  }
  
  func stopLoading() {
    viewController?.stopLoadingAnimation()
  }
  
  func update(wines: [ShortWine], shouldLoadMore: Bool) {
    var sections: [ShowcaseViewModel.Section] = []
    var groupedWines = wines.grouped(map: { $0.winery?.countryCode ?? localized("unknown_country_code") })
    
    groupedWines.sort { (arr1, arr2) -> Bool in
      if let w1 = countryNameFromLocaleCode(countryCode: arr1.first?.winery?.countryCode),
         let w2 = countryNameFromLocaleCode(countryCode: arr2.first?.winery?.countryCode) {
        return w1 < w2
      }
      return false
    }
    
    if groupedWines.count == 1 {
      let wines = wines.compactMap { wine -> WineCollectionViewCellViewModel? in
        WineCollectionViewCellViewModel(
          imageURL: wine.mainImageUrl?.toURL,
          titleText: wine.title,
          subtitleText: countryNameFromLocaleCode(countryCode: wine.winery?.countryCode))
      }
      sections = [.shelf(title: localized("all").firstLetterUppercased(), wines: wines)]
    } else {
      sections = groupedWines.map({ (arrayWine) -> ShowcaseViewModel.Section in
        let wines = arrayWine.compactMap { wine -> WineCollectionViewCellViewModel? in
          WineCollectionViewCellViewModel(
            imageURL: wine.mainImageUrl?.toURL,
            titleText: wine.title,
            subtitleText: countryNameFromLocaleCode(countryCode: wine.winery?.countryCode))
        }
        return .shelf(
          title: countryNameFromLocaleCode(
            countryCode: arrayWine.first?.winery?.countryCode) ?? localized("unknown_country_code"),
          wines: wines)
      })
    }
    
    let title: String?
    switch input.mode {
    case .normal:
      title = input.title
      
    case .advancedSearch:
      title = localized("search_results").firstLetterUppercased()
    }
    
    let viewModel = ShowcaseViewModel(navigationTitle: title, sections: sections)
    viewController?.updateUI(viewModel: viewModel)
  }
  
  func showErrorAlert(error: Error) {
    viewController?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: error.localizedDescription)
  }
  func showNothingFoundErrorAlert() {
    viewController?.showAlert(
      title: localized("nothing_found").firstLetterUppercased(), message: "")
  }
  
  func showInitiallyLoadingError(error: Error) {
    viewController?.updateUI(
      errorViewModel: ErrorViewModel(
        titleText: localized("error").firstLetterUppercased(),
        subtitleText: error.localizedDescription,
        buttonText: localized("reload").firstLetterUppercased()))
  }
}
