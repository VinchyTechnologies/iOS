//
//  StoreShareRoutable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 15.01.2022.
//  Copyright © 2022 Aleksei Smirnov. All rights reserved.
//

import UIKit.UIView

// MARK: - StoreShareType

public enum StoreShareType {
  case fullInfo(affilatedId: Int, titleText: String?, logoURL: URL?, sourceView: UIView)
}

// MARK: - StoreShareRoutable

public protocol StoreShareRoutable: AnyObject {
  func didTapShareStore(type: StoreShareType)
}
