//
//  Button.swift
//  Display
//
//  Created by Алексей Смирнов on 22.12.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

public final class Button: UIButton {
  
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .accent
    setTitleColor(.white, for: .normal)
    titleLabel?.font = Font.bold(18)
    clipsToBounds = true
    layer.cornerCurve = .continuous
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = bounds.height / 2
  }
  
  public func enable() {
    isEnabled = true
    backgroundColor = .accent
    setTitleColor(.white, for: .normal)
  }
  
  public func disable() {
    isEnabled = false
    backgroundColor = .option
    setTitleColor(.blueGray, for: .normal)
  }
}
