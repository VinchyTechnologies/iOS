//
//  VinchyPresenterProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import VinchyCore

protocol VinchyPresenterProtocol: AnyObject {
  func update(compilations: [Compilation])
  func startShimmer()
  func stopPullRefreshing()
  func showAlertEmptyCollection()
}
