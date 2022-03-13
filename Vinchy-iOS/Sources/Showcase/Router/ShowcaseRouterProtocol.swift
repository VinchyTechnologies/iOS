//
//  ShowcaseRouterProtocol.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/22/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import VinchyUI

protocol ShowcaseRouterProtocol: WineDetailRoutable, CollectionShareRoutable, QRRoutable {
  func popToRootQuestions()
}
