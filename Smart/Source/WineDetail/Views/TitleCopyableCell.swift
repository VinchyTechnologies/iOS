//
//  TitleCopyableCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 28.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display
import CommonUI

public struct TitleCopyableCellViewModel: ViewModelProtocol {

  fileprivate let titleText: NSAttributedString?

  public init(titleText: NSAttributedString?) {
    self.titleText = titleText
  }
}

public final class TitleCopyableCell: UICollectionViewCell, Reusable {

  private let label = CopyableLabel()

  public override init(frame: CGRect) {
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

  required init?(coder: NSCoder) { fatalError() }

  public func getCurrentText() -> String? {
    label.attributedText?.string
  }

  public static func height(viewModel: ViewModel, width: CGFloat) -> CGFloat {
    // swiftlint:disable:next force_cast
    let font = viewModel.titleText?.attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.font] as? UIFont ?? Font.regular(14)
    let height = viewModel.titleText?.string.height(forWidth: width, font: font) ?? 44
    return height
  }
}

extension TitleCopyableCell: Decoratable {

  public typealias ViewModel = TitleCopyableCellViewModel

  public func decorate(model: ViewModel) {
    label.attributedText = model.titleText
  }
}
