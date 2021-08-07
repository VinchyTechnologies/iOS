//
//  ButtonView.swift
//  Smart
//
//  Created by Aleksei Smirnov on 26.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import Epoxy
import UIKit

// MARK: - ButtonCollectionCellDelegate

protocol ButtonCollectionCellDelegate: AnyObject {
  func didTapReviewButton(_ button: UIButton)
}

// MARK: - ButtonCollectionCellViewModel

struct ButtonCollectionCellViewModel: ViewModelProtocol, Equatable {
  fileprivate let buttonText: String?

  public init(buttonText: String?) {
    self.buttonText = buttonText
  }
}

// MARK: - ButtonView

final class ButtonView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
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

  // MARK: Internal

  struct Style: Hashable {
  }

  typealias Content = ButtonCollectionCellViewModel


  static var height: CGFloat {
    48
  }

  weak var delegate: ButtonCollectionCellDelegate?

  func setContent(_ content: Content, animated: Bool) {
    button.setTitle(content.buttonText, for: [])
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    button.layer.cornerRadius = bounds.height / 2
    button.clipsToBounds = true
  }

  // MARK: Private

  private let style: Style
  private let button = Button()

  @objc
  private func didTap(_ button: UIButton) {
    delegate?.didTapReviewButton(button)
  }
}
