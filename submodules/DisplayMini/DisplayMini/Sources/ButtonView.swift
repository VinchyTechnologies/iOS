//
//  ButtonView.swift
//  Smart
//
//  Created by Aleksei Smirnov on 26.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import EpoxyCore
import UIKit

// MARK: - ButtonCollectionCellDelegate

public protocol ButtonCollectionCellDelegate: AnyObject {
  func didTapButtonViewButton(_ button: UIButton)
}

// MARK: - ButtonCollectionCellViewModel

public struct ButtonCollectionCellViewModel: ViewModelProtocol, Equatable {
  fileprivate let buttonText: String?

  public init(buttonText: String?) {
    self.buttonText = buttonText
  }
}

// MARK: - ButtonView

public final class ButtonView: UIView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    button.enable()
    button.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
    addSubview(button)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.fill()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public struct Style: Hashable {
    public init() {

    }
  }

  public typealias Content = ButtonCollectionCellViewModel

  public static var height: CGFloat {
    48
  }

  public weak var delegate: ButtonCollectionCellDelegate?

  public func setContent(_ content: Content, animated: Bool) {
    button.setTitle(content.buttonText, for: [])
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    button.layer.cornerRadius = bounds.height / 2
    button.clipsToBounds = true
  }

  // MARK: Private

  private let style: Style
  private let button = Button()

  @objc
  private func didTap(_ button: UIButton) {
    delegate?.didTapButtonViewButton(button)
  }
}
