//
//  WineDetailRouterProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Database
import VinchyCore
import Sheeeeeeeeet

protocol WineDetailRouterProtocol: WineDetailRoutable {
  func presentActivityViewController(items: [Any], button: UIButton)
  func pushToWriteViewController(note: Note, noteText: String?)
  func pushToWriteViewController(wine: Wine)
  func presentEmailController(HTMLText: String?, recipients: [String])
  func showMoreActionSheet(menuItems: [MenuItem], appearance: ActionSheetAppearance, button: UIButton)
}
