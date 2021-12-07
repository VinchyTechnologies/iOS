//
//  WineViewContextMenuTappable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 01.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit.UIView

// MARK: - WineViewContextMenuTappable

public protocol WineViewContextMenuTappable: AnyObject {
  var contextMenuRouter: ActivityRoutable & WriteNoteRoutable { get }
  func didTapShareContextMenu(wineID: Int64, sourceView: UIView)
  func didTapWriteNoteContextMenu(wineID: Int64)
}
