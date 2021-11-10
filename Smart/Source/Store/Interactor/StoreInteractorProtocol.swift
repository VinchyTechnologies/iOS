//
//  StoreInteractorProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

protocol StoreInteractorProtocol: AdvancedSearchOutputDelegate, WineViewContextMenuTappable {
  func viewDidLoad()
  func didSelectWine(wineID: Int64)
  func willDisplayLoadingView()
  func didTapReloadButton()
  func didTapFilterButton()
  func didTapMapButton(button: UIButton)
}
