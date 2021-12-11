//
//  WineShareRoutable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 07.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit.UIView

// MARK: - WineShareType

public enum WineShareType {
  case fullInfo(wineID: Int64, titleText: String?, bottleURL: URL?, sourceView: UIView)
}

// MARK: - WineShareRoutable

public protocol WineShareRoutable: AnyObject {
  func didTapShare(type: WineShareType)
}
