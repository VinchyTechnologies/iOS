//
//  MapDetailStoreRouterProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CoreLocation
import Display
import UIKit
import VinchyUI

protocol MapDetailStoreRouterProtocol: WineDetailRoutable, DismissRoutable {
  func showRoutesActionSheet(storeTitleText: String?, coordinate: CLLocationCoordinate2D, button: UIButton)
}
