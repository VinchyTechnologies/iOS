//
//  ButtonCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 26.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - ButtonCollectionCellDelegate

protocol ButtonCollectionCellDelegate: AnyObject {
  func didTapReviewButton(_ button: UIButton)
}

// MARK: - ButtonCollectionCellViewModel

struct ButtonCollectionCellViewModel: ViewModelProtocol {
  fileprivate let buttonText: String?

  public init(buttonText: String?) {
    self.buttonText = buttonText
  }
}

// MARK: - ButtonCollectionCell

final class ButtonCollectionCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    button.enable()
    button.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
    addSubview(button)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.fill()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Internal

  weak var delegate: ButtonCollectionCellDelegate?

  override func layoutSubviews() {
    super.layoutSubviews()
    button.layer.cornerRadius = bounds.height / 2
    button.clipsToBounds = true
  }

  // MARK: Private

  private let button = Button()

  @objc
  private func didTap(_ button: UIButton) {
    delegate?.didTapReviewButton(button)
  }
}

// MARK: Decoratable

extension ButtonCollectionCell: Decoratable {
  typealias ViewModel = ButtonCollectionCellViewModel

  func decorate(model: ViewModel) {
    button.setTitle(model.buttonText, for: .normal)
  }
}
