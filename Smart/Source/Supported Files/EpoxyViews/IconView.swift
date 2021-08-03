//
//  IconView.swift
//  Smart
//
//  Created by Алексей Смирнов on 04.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
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
    setContent(.init(image: .local(image)), animated: false)
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

  struct Content: Equatable {
    enum Image {
      case local(UIImage?)
      case remote(url: String?)
      case none
    }

    let image: Image

    static func == (lhs: IconView.Content, rhs: IconView.Content) -> Bool {
      switch (lhs.image, rhs.image) {
      case (.local(let lhsImage), .local(let rhsImage)):
        return lhsImage == rhsImage

      case (.remote(let lhsURL), .remote(let rhsURL)):
        return lhsURL == rhsURL

      default:
        return false
      }
    }

  }

  let size: CGSize

  override var intrinsicContentSize: CGSize {
    size
  }

  func setContent(_ content: Content, animated: Bool) {
    switch content.image {
    case .local(let localImage):
      image = localImage

    case .remote(let url):
      loadImage(url: url?.toURL)

    case .none:
      image = nil
    }
  }
}
