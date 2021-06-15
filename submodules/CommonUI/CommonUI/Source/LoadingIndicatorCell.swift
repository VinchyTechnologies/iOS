//
//  LoadingIndicatorCell.swift
//  CommonUI
//
//  Created by Алексей Смирнов on 20.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

public final class LoadingIndicatorCell: UICollectionViewCell, Loadable, Reusable {

  // MARK: Lifecycle

  override public init(frame: CGRect) {
    super.init(frame: frame)
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
