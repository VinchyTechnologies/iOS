//
//  AreYouInStoreInteractorProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 30.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol AreYouInStoreInteractorProtocol: AnyObject {
  func viewDidLoad()
  func didTapStoreButton()
  func didTapBottle(wineID: Int64)
}
