//
//  AreYouInStoreRouterProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 30.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import VinchyUI

protocol AreYouInStoreRouterProtocol: WineDetailRoutable {
  func presentStore(affilatedId: Int)
}
