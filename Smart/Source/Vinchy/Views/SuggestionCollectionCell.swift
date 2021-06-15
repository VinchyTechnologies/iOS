//
//  SuggestionCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 21.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - SuggestionCollectionCellViewModel

struct SuggestionCollectionCellViewModel: ViewModelProtocol, Hashable {
  fileprivate let titleText: String?

  public init(titleText: String?) {
    self.titleText = titleText
  }
}

// MARK: - SuggestionCollectionCell

final class SuggestionCollectionCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    label.font = Font.bold(18)
    label.textColor = .blueGray
    addSubview(label)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Internal

  override func layoutSubviews() {
    super.layoutSubviews()
    label.frame = CGRect(x: 20, y: 0, width: bounds.width - 40, height: bounds.height)
  }

  // MARK: Private

  private let label = UILabel()
}

// MARK: Decoratable

extension SuggestionCollectionCell: Decoratable {
  typealias ViewModel = SuggestionCollectionCellViewModel

  func decorate(model: ViewModel) {
    label.text = model.titleText
  }
}
