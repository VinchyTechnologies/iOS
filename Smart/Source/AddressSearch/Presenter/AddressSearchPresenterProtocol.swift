//
//  AddressSearchPresenterProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 30.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import MapKit

protocol AddressSearchPresenterProtocol: AnyObject {
  func update(response: [CLPlacemark]?)
}
