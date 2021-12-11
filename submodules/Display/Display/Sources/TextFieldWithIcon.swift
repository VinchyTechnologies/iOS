//
//  TextField.swift
//  Display
//
//  Created by Алексей Смирнов on 22.12.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import UIKit

// MARK: - TextField

public final class TextField: SkyFloatingLabelTextField {
  override public init(frame: CGRect) {
    super.init(frame: frame)
    lineColor = .blueGray
    placeholderColor = .blueGray
    titleColor = .blueGray
    selectedLineColor = .blueGray
    selectedTitleColor = .blueGray
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }
}

// MARK: - TextFieldWithIcon

public final class TextFieldWithIcon: SkyFloatingLabelTextFieldWithIcon {
  override public init(frame: CGRect) {
    super.init(frame: frame)
    lineColor = .blueGray
    placeholderColor = .blueGray
    titleColor = .blueGray
    selectedLineColor = .blueGray
    selectedTitleColor = .blueGray
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }
}
