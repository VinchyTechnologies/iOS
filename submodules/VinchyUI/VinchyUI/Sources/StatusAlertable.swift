//
//  StatusAlertable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 07.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit.UIImage

// MARK: - StatusAlertViewModel

public struct StatusAlertViewModel {
  public let image: UIImage?
  public let titleText: String?
  public let descriptionText: String?

  public init(image: UIImage?, titleText: String?, descriptionText: String?) {
    self.image = image
    self.titleText = titleText
    self.descriptionText = descriptionText
  }
}

// MARK: - StatusAlertable

public protocol StatusAlertable {
  func showStatusAlert(viewModel: StatusAlertViewModel)
}
