//
//  ShowcaseInteractor.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/11/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import VinchyCore

final class ShowcaseInteractor {
  
  private enum C {
    static let limit: Int = 40
    static let inset: CGFloat = 10
  }
  
  private var currentPage: Int = -1
  private var shouldLoadMore = true
  
  private let presenter: ShowcasePresenterProtocol
  private let router: ShowcaseRouterProtocol
  private let stateMachine = PagingStateMachine<[ShortWine]>()
  
  private var categoryItems: [ShowcaseViewModel] = []
  
  private var wines: [ShortWine] = []
  private let input: ShowcaseInput
  init(
    input: ShowcaseInput,
    router: ShowcaseRouterProtocol,
    presenter: ShowcasePresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
    configureStateMachine()
  }
  
  private func configureStateMachine() {
    stateMachine.observe { [weak self] (oldState, newState, _) in
      guard let self = self else { return }
      switch newState {
      case let .loaded(data):
        DispatchQueue.main.async {
          self.handleLoadedData(data, oldState: oldState)
        }
      case .loading(let offset):
        self.loadData()
      //        self.loadData(offset: offset)
      
      case .error(let error):
        self.showData(error: error, needLoadMore: false)
        
      case .initial:
        break
      }
    }
  }
  
  func loadData() {
    guard shouldLoadMore else { return }
    currentPage += 1
    DispatchQueue.global(qos: .userInteractive).async {
      switch self.input.mode {
      case .normal(let wines):
        self.shouldLoadMore = false
        self.wines = wines
        self.stateMachine.invokeSuccess(with: wines)
        
      case .advancedSearch(var params):
        params += [("offset", String(self.currentPage)), ("limit", String(C.limit))]
        Wines.shared.getFilteredWines(params: params) { [weak self] result in
          guard let self = self else { return }
          
          switch result {
          case .success(let wines):
            if wines.isEmpty {
              self.shouldLoadMore = false
              self.presenter.showNothingFoundErrorAlert()
            } else {
              self.shouldLoadMore = wines.count == C.limit
            }
            self.wines = wines
            self.stateMachine.invokeSuccess(with: wines)
            self.presenter.stopLoading()
            
          case .failure(let error):
            if self.currentPage == 0 {
              self.currentPage = -1
              self.stateMachine.fail(with: error)
            }
          }
        }
      }
    }
  }
  
  private func loadInitData() {
    stateMachine.load(offset: .zero)
  }
  
  private func loadMoreData() {
    stateMachine.load(offset: wines.count)
  }
  
  private func handleLoadedData(_ data: [ShortWine], oldState: PagingState<[ShortWine]>) {
    wines += data
    let needLoadMore: Bool
    switch oldState {
    case .error, .loaded, .initial:
      needLoadMore = false
      
    case .loading(let offset):
      needLoadMore = wines.count == offset + C.limit
    }
    
    showData(needLoadMore: needLoadMore)
  }
  
  private func showData(error: Error? = nil, needLoadMore: Bool) {
    if let error = error {
      presenter.update(wines: wines, shouldLoadMore: needLoadMore)
      if wines.isEmpty {
        print("show background error")
      } else {
        presenter.showErrorAlert(error: error)
      }
    } else {
      presenter.update(wines: wines, shouldLoadMore: needLoadMore)
    }
  }
}

// MARK: - ShowcaseInteractorProtocol

extension ShowcaseInteractor: ShowcaseInteractorProtocol {
  
  func willDisplayLoadingView() {
    loadMoreData()
  }

  func viewDidLoad() {
    loadInitData()
  }
  
  func didSelectWine(input: ShowcaseInput) {
    router.pushToShowcaseViewController(input: input)
  }
}
