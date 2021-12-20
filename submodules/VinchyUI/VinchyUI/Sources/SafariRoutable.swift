//
//  SafariRoutable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 20.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

public protocol SafariRoutable: AnyObject {
  func presentSafari(url: URL)
}
