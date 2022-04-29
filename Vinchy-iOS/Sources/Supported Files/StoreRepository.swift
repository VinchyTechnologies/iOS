//
//  StoreRepository.swift
//  Smart
//
//  Created by Алексей Смирнов on 28.04.2022.
//  Copyright © 2022 Aleksei Smirnov. All rights reserved.
//

import Database
import VinchyUI
import Widget

final class StoreRepository: StoreRepositoryAdapterProtocol {

  // MARK: Lifecycle

  private init() {

  }

  // MARK: Public

  public static let shared = StoreRepository()

  // MARK: Internal

  func isLiked(affilietedId: Int) -> Bool {
    storesRepository.findAll().first(where: { $0.affilatedId == affilietedId }) != nil
  }

  func saveOrDeleteStoreFromFavourite(affilietedId: Int, title: String?, address: String?, logoURL: String?, completion: (Bool) -> Void) {

    if let dbStore = storesRepository.findAll().first(where: { $0.affilatedId == affilietedId }) {
      storesRepository.remove(dbStore)
      var stores = WidgetStorage.shared.getWidgetStores()
      if stores.contains(where: { $0.id == affilietedId }) {
        stores.removeAll(where: { $0.id == affilietedId })
        WidgetStorage.shared.save(stores: stores)
      }
      completion(false)
//      presenter.setLikedStatus(isLiked: false)
    } else {
      let maxId = storesRepository.findAll().map { $0.id }.max() ?? 0
      let id = maxId + 1
      storesRepository.append(VStore(id: id, affilatedId: affilietedId, title: title, subtitle: address, logoURL: logoURL))
      completion(true)
//      presenter.setLikedStatus(isLiked: true)
//      presenter.showStatusAlertDidLikedSuccessfully()
    }
  }
}
