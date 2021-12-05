//
//  AdFabric.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CoreGraphics
import EpoxyCollectionView
import UIKit
import VinchyUI

// MARK: - ItemModel + AdViewProtocol

typealias AdItem = ItemModel<AdItemView>

// MARK: AdViewProtocol

extension AdItem: AdViewProtocol {

}

// MARK: - AdFabric

final class AdFabric: AdFabricProtocol {

  static let shared = AdFabric()

  func generateGoogleAd(width: CGFloat, rootcontroller: UIViewController) -> AdViewProtocol {
    AdItemView.itemModel(
      dataID: UUID(),
      content: .init(),
      style: .init())
      .setBehaviors { context in
        context.view.adBanner.rootViewController = rootcontroller
      }
      .flowLayoutItemSize(.init(width: width, height: AdItemView.height))
  }
}
