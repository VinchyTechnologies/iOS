//
//  LogOutCell.swift
//  Smart
//
//  Created by Алексей Смирнов on 02.10.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - LogOutCellViewModel

struct LogOutCellViewModel: ViewModelProtocol {
  fileprivate let titleText: String?

  init(titleText: String?) {
    self.titleText = titleText
  }
}

// MARK: - LogOutCell

final class LogOutCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.fill()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  static func height() -> CGFloat {
    48
  }

  // MARK: Private

  private let label: UILabel = {
    $0.textColor = .accent
    $0.font = Font.bold(18)
    $0.textAlignment = .center
    return $0
  }(UILabel())
}

// MARK: Decoratable

extension LogOutCell: Decoratable {
  typealias ViewModel = LogOutCellViewModel

  func decorate(model: ViewModel) {
    label.text = model.titleText
  }
}
