//
//  TextField.swift
//  Display
//
//  Created by Алексей Смирнов on 22.12.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

public final class TextField: SkyFloatingLabelTextField {
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    lineColor = .blueGray
    placeholderColor = .blueGray
    titleColor = .blueGray
    selectedLineColor = .blueGray
    selectedTitleColor = .blueGray
    
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
  
}

public final class TextFieldWithIcon: SkyFloatingLabelTextFieldWithIcon {
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    lineColor = .blueGray
    placeholderColor = .blueGray
    titleColor = .blueGray
    selectedLineColor = .blueGray
    selectedTitleColor = .blueGray
    
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
  
}
