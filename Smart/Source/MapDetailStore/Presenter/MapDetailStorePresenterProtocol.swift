//
//  MapDetailStorePresenterProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import VinchyCore

protocol MapDetailStorePresenterProtocol: AnyObject {
  func startLoading()
  func stopLoading()
  func update(storeInfo: PartnerInfo)
}
