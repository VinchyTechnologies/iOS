//
//  StorePresenterProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol StorePresenterProtocol: AnyObject {
  func update(data: StoreInteractorData, needLoadMore: Bool)
  func startLoading()
  func stopLoading()
  func showErrorAlert(error: Error)
  func showInitiallyLoadingError(error: Error)
  func setLoadingFilters(data: StoreInteractorData)
}
