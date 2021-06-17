//
//  TitleCopyableCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 28.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display
import UIKit

// MARK: - TitleCopyableCellViewModel

public struct TitleCopyableCellViewModel: ViewModelProtocol {
  fileprivate let titleText: NSAttributedString?

  public init(titleText: NSAttributedString?) {
    self.titleText = titleText
  }
}

// MARK: - TitleCopyableCell

public final class TitleCopyableCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override public init(frame: CGRect) {
    super.init(frame: frame)

    label.numberOfLines = 0

    contentView.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      label.topAnchor.constraint(equalTo: contentView.topAnchor),
      label.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
      label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Public

  public static func height(viewModel: ViewModel, width: CGFloat) -> CGFloat {
    // swiftlint:disable:next force_cast
    let font = viewModel.titleText?.attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.font] as? UIFont ?? Font.regular(14)
    let height = viewModel.titleText?.string.height(forWidth: width, font: font) ?? 44
    return height
  }

  public func getCurrentText() -> String? {
    label.attributedText?.string
  }

  // MARK: Private

  private let label = CopyableLabel()
}

// MARK: Decoratable

extension TitleCopyableCell: Decoratable {
  public typealias ViewModel = TitleCopyableCellViewModel

  public func decorate(model: ViewModel) {
    label.attributedText = model.titleText
  }
}
