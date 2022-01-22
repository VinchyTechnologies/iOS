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
  func viewWillAppear()
  func didSelectPartner(affiliatedStoreId: Int)
  func willDisplayLoadingView()
  func didTapReloadButton()
  func isUserSelectedPartnerForEditing(affilatedId: Int) -> Bool
  func didTapEditStore(affilatedId: Int)
  func didTapCancelEditing()
  func didTapAddToWidget()
  func didTapContextMenuRemoveFromWidget(affilatedId: Int)
  func hasChangesForEditing() -> Bool
}
