//
//  ShowcaseInteractor.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/11/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import CommonUI
import VinchyCore
import Display
import StringFormatting

final class ShowcaseInteractor: ShowcaseInteractorProtocol {
  
  private enum C {
    static let limit: Int = 40
    static let inset: CGFloat = 10
  }
  
  var presenter: ShowcasePresenterProtocol
  
  private var currentPage: Int = -1
  private var shouldLoadMore = true

  private var mode: ShowcaseMode = .normal(wines: [])
  private var categoryItems: [CategoryItem] = []
  
  init(presenter: ShowcasePresenterProtocol) {
    self.presenter = presenter
  }
  
  func loadWines(mode: ShowcaseMode) {
    self.mode = mode
    
    switch self.mode {
    case .normal:
      self.loadWines()
    
    case .advancedSearch:
      self.loadMoreWines()
    }
  }
  
  func loadWines() {
    switch self.mode {
    
    case .normal(let wines):
      shouldLoadMore = false
      presenter.update(wines: wines)
      
    case .advancedSearch:
      return
    }
  }
  
  func loadMoreWines() {
    guard shouldLoadMore else { return }
    currentPage += 1
    DispatchQueue.global(qos: .userInteractive).async {
      switch self.mode {
      case .normal:
        return
        
      case .advancedSearch(var params):
        params += [("offset", String(self.currentPage)), ("limit", String(C.limit))]
        Wines.shared.getFilteredWines(params: params) { [weak self] result in
          guard let self = self else { return }
          
          switch result {
          case .success(let wines):
            self.presenter.updateFromServer(wines: wines, params: params)
            if wines.isEmpty {
              self.shouldLoadMore = false
            } else {
              self.shouldLoadMore = wines.count == C.limit
            }
            self.presenter.updateMoreLoader(shouldLoadMore: self.shouldLoadMore)
            
          case .failure(let error):
            if self.currentPage == 0 {
              self.currentPage = -1
              self.presenter.showInitiallyLoadingError(error: error)
            }
          }
        }
      }
    }
  }
}
