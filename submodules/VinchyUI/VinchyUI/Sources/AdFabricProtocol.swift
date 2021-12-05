//
//  AdFabricProtocol.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 05.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import EpoxyCollectionView
import EpoxyCore
import UIKit

// MARK: - AdViewProtocol

public protocol AdViewProtocol {

}

// MARK: - AnyItemModel + AdViewProtocol

extension AnyItemModel: AdViewProtocol {

}

// MARK: - AdFabricProtocol

public protocol AdFabricProtocol {
  func generateGoogleAd(width: CGFloat, rootcontroller: UIViewController) -> AdViewProtocol
}
