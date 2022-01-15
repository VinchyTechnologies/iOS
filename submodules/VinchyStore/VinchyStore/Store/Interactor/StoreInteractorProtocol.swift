//
//  StoreInteractorProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit.UIButton
import VinchyUI

protocol StoreInteractorProtocol: WineViewContextMenuTappable, AdvancedSearchOutputDelegate {
  func viewDidLoad()
  func didSelectWine(wineID: Int64)
  func willDisplayLoadingView()
  func didTapReloadButton()
  func didTapFilterButton()
  func didTapMapButton(button: UIButton)
  func didTapSearchButton()
  func didTapHorizontalWineViewButton(wineID: Int64)
  func didTapLikeButton()
  func didTapShare(button: UIButton)
}
