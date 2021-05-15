//
//  ShowcasePresenterProtocol.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/11/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation
import VinchyCore

protocol ShowcasePresenterProtocol: AnyObject {
  func showErrorAlert(error: Error)
  func showInitiallyLoadingError(error: Error)
  func showNothingFoundErrorView()
  func update(wines: [ShortWine], needLoadMore: Bool)
  func startLoading()
  func stopLoading()
}
