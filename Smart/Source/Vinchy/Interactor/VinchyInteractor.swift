//
//  VinchyInteractor.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import EmailService
import VinchyCore
import Core

//fileprivate let testComilations: [Compilation] = [
//
//    // mini
//
//    Compilation(type: .mini, title: nil, collectionList: [
//        Collection(title: "For Friends", imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSAXgtd40VL-x5zeR2yV74vmOeGPfFDXncO-w&usqp=CAU"),
//
//        Collection(title: "Rendezvous", imageURL: "https://media.istockphoto.com/photos/friends-drinking-red-wine-picture-id953907054?k=6&m=953907054&s=612x612&w=0&h=ZAOu3Bxk353l3532THybmn-z5QzDpF_WKb-A9G8WKuY="),
//
//        Collection(title: "Our Collection", imageURL: "https://mshanken.imgix.net/wso/Articles/2019/IQ_HowToStore_1600.jpg"),
//
//        Collection(title: "Sunrise", imageURL: "https://whales.com/wp-content/uploads/san-juan-cruises-unwined-wine-tasting-cruise-wine-glasses-sunset-e1457632905368.jpg"),
//    ]),
//
//    // bottles
//
//    Compilation(type: .bottles, title: "Vinchy recommends", collectionList: [
//        Collection(wineList: [
//            .wine(wine: Wine(title: "Dehesa Gago G", imageURL: "https://bucket.vinchy.tech/wines/119349230.png", winery: Winery(countryCode: "ESP"))),
//
//            .wine(wine: Wine(title: "Puisseguin-Saint-Émilion", imageURL: "https://bucket.vinchy.tech/wines/6144584.png", winery: Winery(countryCode: "FR"))),
//
//            .wine(wine: Wine(title: "Pino & Toi", imageURL: "https://bucket.vinchy.tech/wines/4546500.png", winery: Winery(countryCode: "IT"))),
//        ]),
//    ]),
//
//    // big
//
//    Compilation(type: .big, title: "Best in France", collectionList: [
//        Collection(title: "Title", imageURL: "https://www.ft.com/__origami/service/image/v2/images/raw/http%3A%2F%2Fcom.ft.imagepublish.upp-prod-us.s3.amazonaws.com%2F9ceb2784-2a51-11ea-84be-a548267b914b?fit=scale-down&source=next&width=700"),
//        Collection(title: "Title", imageURL: "https://p2d7x8x2.stackpathcdn.com/wordpress/wp-content/uploads/2017/12/wine-by-the-glass.jpg"),
//    ])
//]

final class VinchyInteractor {

  private enum C {
    static let searchSuggestionsCount = 10
  }

  private let dispatchGroup = DispatchGroup()
  private let emailService = EmailService()

  private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
    guard let self = self else { return }
    self.presenter.startLoading()
  }

  private lazy var searchWorkItem = WorkItem()

  private let router: VinchyRouterProtocol
  private let presenter: VinchyPresenterProtocol

  init(
    router: VinchyRouterProtocol,
    presenter: VinchyPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }

  private func fetchData() {

    dispatchGroup.enter()

    var compilations: [Compilation] = []

    Compilations.shared.getCompilations { [weak self] result in
      switch result {
      case .success(let model):
        compilations = model

      case .failure(let error):
        print(error.localizedDescription)
      }

      self?.dispatchGroup.leave()
    }

    dispatchGroup.notify(queue: .main) { [weak self] in
      guard let self = self else { return }

      self.dispatchWorkItemHud.cancel()

      if isShareUsEnabled {
        let shareUs = Compilation(type: .shareUs, title: nil, collectionList: [])
        compilations.insert(shareUs, at: compilations.isEmpty ? 0 : min(3, compilations.count - 1))
      }

      if isSmartFilterAvailable {
        let smartFilter = Compilation(type: .smartFilter, title: nil, collectionList: [])
        compilations.insert(smartFilter, at: 1)
      }

      self.presenter.update(compilations: compilations)
    }
  }

  private func fetchSearchSuggestions() {

    Wines.shared.getRandomWines(count: C.searchSuggestionsCount) { [weak self] result in
      guard let self = self else { return }

      switch result {
      case .success(let model):
        self.presenter.update(suggestions: model)

      case .failure:
        break
      }
    }
  }
}

extension VinchyInteractor: VinchyInteractorProtocol {

  func didTapSearchButton(searchText: String?) {

    guard let searchText = searchText else {
      return
    }

    router.pushToDetailCollection(searchText: searchText)
  }

  func didEnterSearchText(_ searchText: String?) {

    guard
      let searchText = searchText,
      !searchText.isEmpty
    else {
      return
    }

    searchWorkItem.perform(after: 0.65) {
      Wines.shared.getWineBy(title: searchText, offset: 0, limit: 40) { [weak self] result in
        switch result {
        case .success(let wines):
          self?.presenter.update(didFindWines: wines)

        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }
  }

  func viewDidLoad() {
    fetchData()
    fetchSearchSuggestions()

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.dispatchWorkItemHud.perform()
    }
  }

  func didPullToRefresh() {
    fetchData()
  }

  func didTapFilter() {
    router.pushToAdvancedFilterViewController()
  }

  func didTapDidnotFindWineFromSearch(searchText: String?) {

    guard let searchText = searchText else {
      return
    }

    if emailService.canSend {
      router.presentEmailController(
        HTMLText: presenter.cantFindWineText + searchText,
        recipients: presenter.cantFindWineRecipients)
    } else {
      presenter.showAlertCantOpenEmail()
    }
  }
}
