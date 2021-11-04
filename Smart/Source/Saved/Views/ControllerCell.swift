//
//  ControllerCell.swift
//  Smart
//
//  Created by Алексей Смирнов on 03.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import EpoxyCore
import UIKit

// MARK: - ControllerCell

final class ControllerCell: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    self.style = style
    super.init(frame: .zero)

//    let view = UIView()
//    addSubview(view)
//    view.translatesAutoresizingMaskIntoConstraints = false
//    view.backgroundColor = .red
//    view.fill()
//
//    let view1 = UIView()
//    view1.backgroundColor = .gray
//    view.addSubview(view1)
//    view1.translatesAutoresizingMaskIntoConstraints = false
//    view1.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//    view1.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//    view1.widthAnchor.constraint(equalToConstant: 50).isActive = true
//    view1.heightAnchor.constraint(equalToConstant: 50).isActive = true
    addSubview(vc.view)
    vc.view.frame = bounds
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

  let vc = LoveViewController()//DocumentsAssembly.assemblyModule()//LoveViewController()

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
