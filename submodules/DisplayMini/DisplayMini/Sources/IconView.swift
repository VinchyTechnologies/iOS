//
//  IconView.swift
//  Smart
//
//  Created by Алексей Смирнов on 04.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import EpoxyCore
import UIKit

public final class IconView: UIImageView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    size = style.size
    super.init(image: nil)
    translatesAutoresizingMaskIntoConstraints = false
    tintColor = style.tintColor
    if style.isRounded {
      layer.cornerRadius = size.height / 2
      clipsToBounds = true
    }

    widthAnchor.constraint(greaterThanOrEqualToConstant: size.width).isActive = true

    contentMode = .scaleAspectFit
    setContentHuggingPriority(.required, for: .vertical)
    setContentHuggingPriority(.required, for: .horizontal)
    setContentCompressionResistancePriority(.required, for: .horizontal)
    setContentCompressionResistancePriority(.required, for: .vertical)
  }

  public convenience init(image: UIImage?, size: CGSize) {
    self.init(style: .init(size: size, tintColor: .systemBlue))
    setContent(.init(image: .local(image)), animated: false)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public struct Style: Hashable {
    public var size: CGSize
    public var tintColor: UIColor = .systemBlue
    public var isRounded: Bool = false
    // TODO: - imageConfig

    public func hash(into hasher: inout Hasher) {
      hasher.combine(size.width)
      hasher.combine(size.height)
      hasher.combine(tintColor)
      hasher.combine(isRounded)
    }

    public init(size: CGSize, tintColor: UIColor = .systemBlue, isRounded: Bool = false) {
      self.size = size
      self.tintColor = tintColor
      self.isRounded = isRounded
    }
  }

  public struct Content: Equatable {

    // MARK: Lifecycle

    public init(image: Image) {
      self.image = image
    }

    // MARK: Public

    public enum Image {
      case local(UIImage?)
      case remote(url: String?)
      case bottle(url: String?)
      case none
    }

    public let image: Image

    public static func == (lhs: IconView.Content, rhs: IconView.Content) -> Bool {
      switch (lhs.image, rhs.image) {
      case (.local(let lhsImage), .local(let rhsImage)):
        return lhsImage == rhsImage

      case (.remote(let lhsURL), .remote(let rhsURL)):
        return lhsURL == rhsURL

      case (.bottle(let lhsURL), .bottle(let rhsURL)):
        return lhsURL == rhsURL

      default:
        return false
      }
    }
  }

  public let size: CGSize

  public override var intrinsicContentSize: CGSize {
    size
  }

  public func setContent(_ content: Content, animated: Bool) {
    switch content.image {
    case .local(let localImage):
      image = localImage

    case .remote(let url):
      loadImage(url: url?.toURL)

    case .bottle(let url):
      loadBottle(url: url?.toURL)

    case .none:
      image = nil
    }
  }
}
