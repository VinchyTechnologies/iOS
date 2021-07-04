//
//  IconView.swift
//  Smart
//
//  Created by Алексей Смирнов on 04.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import EpoxyCore
import UIKit

final class IconView: UIImageView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    size = style.size
    super.init(image: nil)
    translatesAutoresizingMaskIntoConstraints = false
    tintColor = style.tintColor
    setContentHuggingPriority(.required, for: .vertical)
    setContentHuggingPriority(.required, for: .horizontal)
    setContentCompressionResistancePriority(.required, for: .horizontal)
    setContentCompressionResistancePriority(.required, for: .vertical)
  }

  convenience init(image: UIImage?, size: CGSize) {
    self.init(style: .init(size: size, tintColor: .systemBlue))
    setContent(image, animated: false)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {
    var size: CGSize
    var tintColor: UIColor = .systemBlue
    // TODO: - imageConfig

    func hash(into hasher: inout Hasher) {
      hasher.combine(size.width)
      hasher.combine(size.height)
      hasher.combine(tintColor)
    }
  }

  let size: CGSize

  override var intrinsicContentSize: CGSize {
    size
  }

  func setContent(_ content: UIImage?, animated: Bool) {
    image = content
  }

}
