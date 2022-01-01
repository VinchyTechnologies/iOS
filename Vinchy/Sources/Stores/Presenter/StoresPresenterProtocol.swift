//
//  StoresPresenterProtocol.swift
//  Smart
//
//  Created by Михаил Исаченко on 08.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import VinchyCore

protocol StoresPresenterProtocol: AnyObject {
  func update(partnersInfo: [PartnerInfo], needLoadMore: Bool)
  func startLoading()
  func stopLoading()
  func showErrorAlert(error: Error)
  func showInitiallyLoadingError(error: Error)
  func showNoSavedStores()
}
