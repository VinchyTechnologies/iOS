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
    
    if let dbWine = realm(path: .dislike).objects(DBWine.self).first(where: { $0.wineID == wine.id }) {
      dataBase.remove(object: dbWine, at: .dislike)
    } else {
      dataBase.add(object: DBWine(id: dataBase.incrementID(path: .dislike), wineID: wine.id, mainImageUrl: wine.mainImageUrl ?? "", title: wine.title), at: .dislike)
    }
  }
  
  func didTapShareButton() {
    
    guard let wine = wine else { return }
    let items = [wine.title]
    router.presentActivityViewController(items: items)
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
  
  func didTapLikeButton() {
    
    guard let wine = wine else { return }
    
    if let dbWine = realm(path: .like).objects(DBWine.self).first(where: { $0.wineID == wine.id }) {
      dataBase.remove(object: dbWine, at: .like)
    } else {
      dataBase.add(object: DBWine(id: dataBase.incrementID(path: .like), wineID: wine.id, mainImageUrl: wine.mainImageUrl ?? "", title: wine.title), at: .like)
    }
  }
}
