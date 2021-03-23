//
//  WineDetailInteractor.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import VinchyCore
import Database
import EmailService
import Sheeeeeeeeet
import FirebaseDynamicLinks
import VinchyAuthorization
import Core

enum WineDetailMoreActions {
  case reportAnError
  case dislike
}

private enum ActionAfterLoginOrRegistration {
  case writeReview
  case none
}

final class WineDetailInteractor {
  
  private let router: WineDetailRouterProtocol
  private let presenter: WineDetailPresenterProtocol
  private let input: WineDetailInput
  
  private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
    guard let self = self else { return }
    self.presenter.startLoading()
  }
  private var rate: Double?
  private let dataBase = CoreDatabase<CDWine>()
  private let emailService = EmailService()
  
  private var wine: Wine?
  
  private var actionAfterAuthorization: ActionAfterLoginOrRegistration = .none
  
  init(
    input: WineDetailInput,
    router: WineDetailRouterProtocol,
    presenter: WineDetailPresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
  }
  
  private func loadWineInfo() {
    
    Wines.shared.getDetailWine(wineID: input.wineID) { [weak self] result in
      
      guard let self = self else { return }
      
      self.dispatchWorkItemHud.cancel()
      DispatchQueue.main.async {
        self.presenter.stopLoading()
      }
      
      switch result {
      case .success(let wine):
        self.presenter.update(
          wine: wine,
          isLiked: self.isFavourite(wine: wine),
          isDisliked: self.isDisliked(wine: wine),
          rate: self.rate ?? 0,
          currency: UserDefaultsConfig.currency)
        self.wine = wine
        
      case .failure(let error):
        self.presenter.showNetworkErrorAlert(error: error)
      }
    }
  }
  
  private func isFavourite(wine: Wine) -> Bool {
    let predicate = NSPredicate(format: "(review.estimation = %@) AND (wineID = %@)", Estimation.like.rawValue, String(wine.id))
    return dataBase.fetchAll(
      entityName: "CDWine",
      predicate: predicate).count == 1
  }
  
  private func isDisliked(wine: Wine) -> Bool {
    let predicate = NSPredicate(format: "(review.estimation = %@) AND (wineID = %@)", Estimation.dislike.rawValue, String(wine.id))
    return dataBase.fetchAll(
      entityName: "CDWine",
      predicate: predicate).count == 1
  }
}

// MARK: - WineDetailInteractorProtocol

extension WineDetailInteractor: WineDetailInteractorProtocol {
  
  func didSuccessfullyLoginOrRegister() {
    switch actionAfterAuthorization {
    case .writeReview:
      didTapWriteReviewButton()
      
    case .none:
      break
    }
  }
  
  func didTapReview(reviewID: Int) {
    guard
      let wine = wine,
      let review = wine.reviews.first(where: { $0.id == reviewID })
    else {
      return
    }
    
    let dateText: String?
    if review.updateDate == nil {
      dateText = review.publicationDate.toDate()
    } else {
      dateText = review.updateDate.toDate()
    }
    
    router.showBottomSheetReviewDetailViewController(reviewInput: .init(rate: review.rating, author: nil, date: dateText, reviewText: review.comment))
  }

  func didTapSeeAllReviews() {
    guard let wineID = wine?.id else {
      return
    }
    router.pushToReviewsViewController(wineID: wineID)
  }
  
  func didTapWriteReviewButton() {
    
    print(#function)
    
    guard let wineID = wine?.id else {
      return
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.dispatchWorkItemHud.perform()
    }
    
    if UserDefaultsConfig.accountID != 0 {
      Reviews.shared.getReviews(
        wineID: wineID,
        accountID: UserDefaultsConfig.accountID,
        offset: 0,
        limit: 1) { [weak self] result in
        
        guard let self = self else { return }
        
        self.dispatchWorkItemHud.cancel()
        DispatchQueue.main.async {
          self.presenter.stopLoading()
        }
        
        switch result {
        case .success(let model):
          guard let review = model.first else {
            self.router.presentWriteReviewViewController(reviewID: nil, wineID: wineID, rating: 0, reviewText: nil)
            return
          }
          self.router.presentWriteReviewViewController(
            reviewID: review.id,
            wineID: wineID,
            rating: review.rating,
            reviewText: review.comment)
          
        case .failure:
          self.router.presentWriteReviewViewController(reviewID: nil, wineID: wineID, rating: 0, reviewText: nil)
        }
      }
    } else {
      actionAfterAuthorization = .writeReview
      router.presentAuthorizationViewController()
    }
  }

  func didTapMore(_ button: UIButton) {
    guard let wine = wine else { return }
    var menuItems: [MenuItem] = []

    let imageName = isDisliked(wine: wine) ? "heart.slash.fill" : "heart.slash"

    let dislikeMenuItem = MenuItem(
      title: presenter.dislikeText ?? "",
      subtitle: nil,
      value: WineDetailMoreActions.dislike,
      image: UIImage(systemName: imageName),
      isEnabled: true,
      tapBehavior: .none)

    let reportAnErrorMenuItem = MenuItem(
      title: presenter.reportAnErrorText ?? "",
      subtitle: nil,
      value: WineDetailMoreActions.reportAnError,
      image: nil,
      isEnabled: true,
      tapBehavior: .none)

    menuItems.append(dislikeMenuItem)
    menuItems.append(reportAnErrorMenuItem)
    
    router.showMoreActionSheet(menuItems: menuItems, appearance: VinchyActionSheetAppearance(), button: button)
  }
  
  func didTapPriceButton() {
    
  }
  
  func didTapReportAnError() {
    
    guard let wine = wine else { return }
    
    if emailService.canSend {
      router.presentEmailController(HTMLText: wine.title, recipients: presenter.reportAnErrorRecipients)
    } else {
      presenter.showAlertCantOpenEmail()
    }
  }
  
  func didTapDislikeButton() {
    
    guard let wine = wine else { return }

    if isFavourite(wine: wine) {
      presenter.showAlertWineAlreadyLiked()
      return
    }
    
    if let dbWine = dataBase.fetchAll(
        entityName: "CDWine",
        predicate: NSPredicate(format: "wineID = %@", String(wine.id))).first {
      
      if dbWine.review?.noteText == nil || dbWine.review?.noteText == "" {
        dataBase.persistentContainer.viewContext.delete(dbWine)
        dataBase.saveContext()
      } else {
        dbWine.review?.estimation = .none
        dataBase.saveContext()
      }
    } else {
      let entity = CDWine(context: dataBase.persistentContainer.viewContext)
      entity.setValues(wineID: wine.id, title: wine.title)
      let review = CDReview(context: dataBase.persistentContainer.viewContext)
      review.setValues(estimation: .dislike, noteText: nil, wine: entity)
      dataBase.saveContext()
      presenter.showStatusAlertDidDislikedSuccessfully()
    }
  }
  
  func didTapShareButton(_ button: UIButton) {
    
    guard let wine = wine else { return }

    var components = URLComponents()
    components.scheme = Scheme.https.rawValue
    components.host = domain
    components.path = "/wines/" + String(wine.id)

    guard let linkParameter = components.url else {
      return
    }

    guard
      let shareLink = DynamicLinkComponents(
            link: linkParameter,
            domainURIPrefix: "https://vinchy.page.link") else {
      return
    }

    if let bundleID = Bundle.main.bundleIdentifier {
      shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: bundleID)
    }
    shareLink.iOSParameters?.appStoreID = "1536720416"
    shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
    shareLink.socialMetaTagParameters?.title = wine.title
    shareLink.socialMetaTagParameters?.imageURL = wine.mainImageUrl?.toURL

    shareLink.shorten { [weak self] (url, _, error) in
      if error != nil {
        return
      }

      guard let url = url else { return }

      let items = [wine.title, url] as [Any]
      self?.router.presentActivityViewController(items: items, button: button)
    }
  }
  
  func viewDidLoad() {
    loadWineInfo()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.dispatchWorkItemHud.perform()
    }
  }
  
  func didTapNotes() {
    
    guard let wine = wine else { return }
    
    if let note = realm(path: .notes).objects(Note.self).first(where: { $0.wineID == wine.id }) {
      router.pushToWriteViewController(note: note, noteText: note.noteText)
    } else {
      router.pushToWriteViewController(wine: wine)
    }
  }
  
  func didTapLikeButton(_ button: UIButton) {
    
    guard let wine = wine else { return }

    if isDisliked(wine: wine) {
      button.isSelected = !button.isSelected
      presenter.showAlertWineAlreadyDisliked()
      return
    }
    
    if let dbWine = dataBase.fetchAll(
        entityName: "CDWine",
        predicate: NSPredicate(format: "wineID = %@", String(wine.id))).first {
      
      if dbWine.review?.noteText == nil || dbWine.review?.noteText == "" {
        dataBase.persistentContainer.viewContext.delete(dbWine)
        dataBase.saveContext()
      } else {
        dbWine.review?.estimation = .none
        dataBase.saveContext()
      }
    } else {
      let entity = CDWine(context: dataBase.persistentContainer.viewContext)
      entity.setValues(wineID: wine.id, title: wine.title)
      let review = CDReview(context: dataBase.persistentContainer.viewContext)
      review.setValues(estimation: .like, noteText: nil, wine: entity)
      dataBase.saveContext()
      presenter.showStatusAlertDidLikedSuccessfully()
    }
  }

  func didTapSimilarWine(wineID: Int64) {
    router.pushToWineDetailViewController(wineID: wineID)
  }
}
