//
//  VinchyActionSheetAppearence.swift
//  WineDetail
//
//  Created by Алексей Смирнов on 02.12.2021.
//

import Display
import Sheeeeeeeeet

final class VinchyActionSheetAppearance: ActionSheetAppearance {
  override func applyFonts() {
    super.applyFonts()
    item.titleFont = Font.medium(16)
  }

  override func applyColors() {
    super.applyColors()
    item.titleColor = .dark
  }
}
