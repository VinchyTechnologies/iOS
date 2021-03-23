//
//  ShowcaseViewControllerProtocol.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/11/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display

protocol ShowcaseViewControllerProtocol: Alertable {
  func update(category: [CategoryItem])
  func updateUI(errorViewModel: ErrorViewModel)
  func stopLoading()
  func updateMoreLoader(shouldLoadMore: Bool)
}
