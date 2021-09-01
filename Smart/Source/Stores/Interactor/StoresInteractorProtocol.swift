//
//  StoresInteractorProtocol.swift
//  Smart
//
//  Created by Михаил Исаченко on 08.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol StoresInteractorProtocol: AnyObject {
  func viewDidLoad()
  func didSelectPartner(affiliatedStoreId: Int)
  func willDisplayLoadingView()
  func didTapReloadButton()
}
