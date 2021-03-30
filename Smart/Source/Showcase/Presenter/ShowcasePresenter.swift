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
  var categories: [CategoryItemViewModel] = []
  
  // MARK: - Initializers
  
  init(viewController: ShowcaseViewControllerProtocol) {
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
  
  func update(wines: [ShortWine]) {
    var groupedWines = wines.grouped(map: { $0.winery?.countryCode ?? localized("unknown_country_code") })
    
    groupedWines.sort { (arr1, arr2) -> Bool in
      if let w1 = countryNameFromLocaleCode(countryCode: arr1.first?.winery?.countryCode),
         let w2 = countryNameFromLocaleCode(countryCode: arr2.first?.winery?.countryCode) {
        return w1 < w2
      }
      return false
    }
    
    if groupedWines.count == 1 {
      categories = [.init(title: "", wines: wines)]
      return
    }
    categories = groupedWines.map({ (arrayWine) -> CategoryItemViewModel in
      return CategoryItemViewModel(title: countryNameFromLocaleCode(countryCode: arrayWine.first?.winery?.countryCode) ?? localized("unknown_country_code"), wines: arrayWine)
    })
    
    viewController?.updateUI(viewModel: categories)
    stopLoading()
  }
  
  func updateFromServer(wines: [ShortWine], params: [(String, String)]) {
    stopLoading()
    if categories.first == nil {
      if params.first?.0 == "title" && params.count == 3 {
        self.categories = [.init(title: params.first?.1.quoted ?? "", wines: wines)]
      } else {
        self.categories = [.init(title: localized("all").firstLetterUppercased(), wines: wines)]
      }
    } else {
      self.categories[0].wines += wines
    }
    
    if wines.isEmpty {
      showNothingFoundErrorAlert()
      return
    } else {
      viewController?.updateUI(viewModel: categories)
    }
  }
  
  func updateMoreLoader(shouldLoadMore: Bool) {
    viewController?.updateMoreLoader(shouldLoadMore: shouldLoadMore)
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
