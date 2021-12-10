//
//  TextCollectionCell.swift
//  DisplayMini
//
//  Created by Aleksei Smirnov on 25.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - TextCollectionCellViewModel

public struct TextCollectionCellViewModel: ViewModelProtocol {
  fileprivate let titleText: NSAttributedString?

  public init(titleText: NSAttributedString?) {
    self.titleText = titleText
  }
}

// MARK: - TextCollectionCell

public final class TextCollectionCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override public init(frame: CGRect) {
    super.init(frame: frame)

    label.numberOfLines = 0

    contentView.addSubview(label)
    label.fill()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Public

  public static func height(viewModel: ViewModel?, width: CGFloat) -> CGFloat {
    guard let viewModel = viewModel else {
      return 0
    }
    // swiftlint:disable:next force_cast
    let font = viewModel.titleText?.attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.font] as? UIFont ?? Font.regular(14)
    let height = viewModel.titleText?.string.height(forWidth: width, font: font) ?? 44
    return height
  }

  public func getCurrentText() -> String? {
    label.attributedText?.string
  }

  // MARK: Private

  private let label = UILabel()
}

// MARK: Decoratable

extension TextCollectionCell: Decoratable {
  public typealias ViewModel = TextCollectionCellViewModel

  public func decorate(model: ViewModel) {
    label.attributedText = model.titleText
  }
}
