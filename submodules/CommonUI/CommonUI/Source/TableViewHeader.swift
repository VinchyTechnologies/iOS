//
//  TableViewHeader.swift
//  CommonUI
//
//  Created by Aleksei Smirnov on 18.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - TableViewHeaderViewModel

public struct TableViewHeaderViewModel: ViewModelProtocol {
  fileprivate let titleText: String?

  public init(titleText: String?) {
    self.titleText = titleText
  }
}

// MARK: - TableViewHeader

public final class TableViewHeader: UIView {

  // MARK: Lifecycle

  override public init(frame: CGRect) {
    super.init(frame: frame)
    titleLabel.font = Font.medium(20)
    titleLabel.textColor = .blueGray
    addSubview(titleLabel)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Public

  override public func layoutSubviews() {
    super.layoutSubviews()
    titleLabel.frame = CGRect(x: 20, y: 0, width: frame.width - 40, height: frame.height)
  }

  // MARK: Private

  private let titleLabel = UILabel()
}

// MARK: Decoratable

extension TableViewHeader: Decoratable {
  public typealias ViewModel = TableViewHeaderViewModel

  public func decorate(model: ViewModel) {
    titleLabel.text = model.titleText
  }
}
