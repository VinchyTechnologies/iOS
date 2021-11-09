//
//  ControllerCell.swift
//  Smart
//
//  Created by Алексей Смирнов on 03.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Epoxy
import UIKit

// MARK: - ControllerCell

final class ControllerCell: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    directionalLayoutMargins = .zero
    addSubview(vc.view)
    vc.view.translatesAutoresizingMaskIntoConstraints = false
    vc.view.constrainToMargins()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {
    var id: String
  }

  struct Content: Equatable {
    let id: String
  }

  let vc = WineDetailAssembly.assemblyModule(input: .init(wineID: 891))//DocumentsAssembly.assemblyModule()//LoveViewController()

  func setContent(_ content: Content, animated: Bool) {
//    guard let addedView = content.viewController.view else {
//      return
//    }
//    addSubview(addedView)
//    addedView.fill()
  }

  // MARK: Private

  private let style: Style

}
