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
  
  public private(set) var loadingIndicator = ActivityIndicatorView()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    addLoader()
    startLoadingAnimation()
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    startLoadingAnimation()
  }
}
