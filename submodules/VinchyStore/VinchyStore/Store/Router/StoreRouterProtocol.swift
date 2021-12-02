//
//  StoreRouterProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import CoreLocation
import UIKit.UIButton
import VinchyAuthorization
import VinchyUI

protocol StoreRouterProtocol: WineDetailRoutable, ActivityRoutable, WriteNoteRoutable, OpenURLProtocol, ResultsSearchRoutable {
  func presentFilter(preselectedFilters: [(String, String)])
  func showRoutesActionSheet(storeTitleText: String?, coordinate: CLLocationCoordinate2D, button: UIButton)
}
