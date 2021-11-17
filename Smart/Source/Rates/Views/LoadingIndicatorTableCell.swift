//
//  LoadingIndicatorTableCell.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

public final class LoadingIndicatorTableCell: UITableViewCell, Loadable, Reusable {

  // MARK: Lifecycle

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    contentView.backgroundColor = .mainBackground
    backgroundColor = .mainBackground
    addLoader()
    startLoadingAnimation()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Public

  public private(set) var loadingIndicator = ActivityIndicatorView()

  override public func prepareForReuse() {
    super.prepareForReuse()
    startLoadingAnimation()
  }
}
