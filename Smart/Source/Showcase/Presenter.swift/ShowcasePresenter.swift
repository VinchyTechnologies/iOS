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
  
  var viewController: ShowcaseViewControllerProtocol?
  var input: ShowcaseInput?
  var title: String?
  
  // MARK: - Initializers
  
  init(viewController: ShowcaseViewControllerProtocol, input: ShowcaseInput) {
    self.viewController = viewController
    self.input = input
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
    var sections: [ShowcaseWineSection] = []
    var groupedWines = wines.grouped(map: { $0.winery?.countryCode ?? localized("unknown_country_code") })
    
    groupedWines.sort { (arr1, arr2) -> Bool in
      if let w1 = countryNameFromLocaleCode(countryCode: arr1.first?.winery?.countryCode),
         let w2 = countryNameFromLocaleCode(countryCode: arr2.first?.winery?.countryCode) {
        return w1 < w2
      }
      viewController?.updateMoreLoader(shouldLoadMore: shouldLoadMore)
      return false
    }
    
    if groupedWines.count == 1 {
      sections = [.init(title: localized("all").firstLetterUppercased(), wines: wines)]
    } else {
      sections = groupedWines.map({ (arrayWine) -> ShowcaseWineSection in
        return ShowcaseWineSection(title: countryNameFromLocaleCode(countryCode: arrayWine.first?.winery?.countryCode) ?? localized("unknown_country_code"), wines: arrayWine)
      })
    }
    
    switch input?.mode {
    case .normal:
      self.title = input?.title ?? ""
    case .advancedSearch:
      self.title = localized("search_results").firstLetterUppercased()
    case .none:
      break
    }
    
    let viewModel = ShowcaseViewModel(navigationTitle: self.title, sections: sections)
    viewController?.updateUI(viewModel: viewModel)
    stopLoading()
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
