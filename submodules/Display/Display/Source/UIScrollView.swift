//
//  UIScrollView.swift
//  Display
//
//  Created by Алексей Смирнов on 01.10.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import UIKit

extension UIScrollView {
  public func scrollToTopForcingSearchBar() {
    let scrollToTopIfPossibleSelector = Selector(encodeText("`tdspmmUpUpqJgQpttjcmf;", -1))
    if responds(to: scrollToTopIfPossibleSelector) {
      perform(scrollToTopIfPossibleSelector)
    }
  }
}
