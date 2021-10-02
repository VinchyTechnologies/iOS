//
//  AddressSearchPresenterProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 30.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import MapKit

protocol AddressSearchPresenterProtocol: AnyObject {

  var alertLocationServiceSettingsTitleText: String? { get }
  var alertLocationServiceSettingSubtitleText: String? { get }
  var alertLocationServiceSettingsLeadingButtonText: String? { get }
  var alertLocationServiceSettingsTrailingButtonText: String? { get }

  func update(response: [CLPlacemark]?)
}
