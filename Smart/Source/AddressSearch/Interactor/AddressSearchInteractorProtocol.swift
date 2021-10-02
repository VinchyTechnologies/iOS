//
//  AddressSearchInteractorProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 30.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol AddressSearchInteractorProtocol: AnyObject {
  func viewDidLoad()
  func didEnterSearchText(_ text: String?)
  func didSelectAddressRow(id: Int)
  func didSelectCurrentGeo()
  func didTapGoToSettingToTurnOnLocationService()
}
