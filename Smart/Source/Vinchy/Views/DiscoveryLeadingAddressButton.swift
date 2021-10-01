//
//  DiscoveryLeadingAddressButton.swift
//  Smart
//
//  Created by Алексей Смирнов on 01.10.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display

// MARK: - DiscoveryLeadingAddressButtonMode

enum DiscoveryLeadingAddressButtonMode {
  case loading(text: String?)
  case arraw(text: String?)
}

// MARK: - DiscoveryLeadingAddressButton

final class DiscoveryLeadingAddressButton: UIButton {

  static func build(mode: DiscoveryLeadingAddressButtonMode) -> Self {

    let addressButton = Self(type: .system)
    addressButton.setTitleColor(.dark, for: [])
    addressButton.titleLabel?.font = Font.bold(18)
    addressButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    addressButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    addressButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    addressButton.setInsets(forContentPadding: .zero, imageTitlePadding: 3)

    switch mode {
    case .loading(let text):
      addressButton.setTitle(text, for: [])
      addressButton.setImage(nil, for: [])

    case .arraw(let text):
      let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold, scale: .default)
      addressButton.setImage(UIImage(systemName: "chevron.down", withConfiguration: imageConfig), for: [])
      addressButton.setTitle(text, for: [])
    }
    addressButton.layoutIfNeeded()
    return addressButton
  }
}
