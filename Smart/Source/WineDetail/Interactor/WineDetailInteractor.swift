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

enum WineDetailMoreActions {
  case reportAnError
  case dislike
}

final class WineDetailInteractor {
  
  private let router: WineDetailRouterProtocol
  private let presenter: WineDetailPresenterProtocol
  private let input: WineDetailInput
  
  private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
    guard let self = self else { return }
    self.presenter.startLoading()
  }
  
  private let dataBase = Database<DBWine>()
  private let emailService = EmailService()
  
  private var wine: Wine?
  
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
          isDisliked: self.isDisliked(wine: wine))
        self.wine = wine
        
      case .failure(let error):
        self.presenter.showNetworkErrorAlert(error: error)
      }
    }
  }
  
  private func isFavourite(wine: Wine) -> Bool {
    realm(path: .like).objects(DBWine.self).first(where: { $0.wineID == wine.id }) != nil
  }
  
  private func isDisliked(wine: Wine) -> Bool {
    realm(path: .dislike).objects(DBWine.self).first(where: { $0.wineID == wine.id }) != nil
  }
}

// MARK: - WineDetailInteractorProtocol

extension WineDetailInteractor: WineDetailInteractorProtocol {

  func didTapMore() {
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
    
    router.showMoreActionSheet(menuItems: menuItems, appearance: VinchyActionSheetAppearance())
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
    
    if let dbWine = realm(path: .dislike).objects(DBWine.self).first(where: { $0.wineID == wine.id }) {
      dataBase.remove(object: dbWine, at: .dislike)
    } else {
      dataBase.add(object: DBWine(id: dataBase.incrementID(path: .dislike), wineID: wine.id, title: wine.title), at: .dislike)
      presenter.showStatusAlertDidDislikedSuccessfully()
    }
  }
  
  func didTapShareButton() {
    
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
      self?.router.presentActivityViewController(items: items)

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
    
    if let dbWine = realm(path: .like).objects(DBWine.self).first(where: { $0.wineID == wine.id }) {
      dataBase.remove(object: dbWine, at: .like)
    } else {
      dataBase.add(object: DBWine(id: dataBase.incrementID(path: .like), wineID: wine.id, title: wine.title), at: .like)
      presenter.showStatusAlertDidLikedSuccessfully()
    }
  }
}
