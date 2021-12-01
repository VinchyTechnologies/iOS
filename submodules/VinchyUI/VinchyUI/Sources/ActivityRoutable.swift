//
//  ActivityRoutable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 01.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit.UIView

public protocol ActivityRoutable {
  func presentActivityViewController(items: [Any], sourceView: UIView)
}
