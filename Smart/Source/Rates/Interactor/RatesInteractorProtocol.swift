//
//  RatesInteractorProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol RatesInteractorProtocol: AnyObject {
  func viewDidLoad()
  func willDisplayLoadingView()
  func didSelectReview(id: Int)
}
