//
//  QRViewModel.swift
//  Questions
//
//  Created by Алексей Смирнов on 13.03.2022.
//

import DisplayMini

struct QRViewModel {

  enum Section {
    case logo(content: LogoRow.Content)
    case address(content: StoreMapRow.Content)
    case title(content: Label.Content)
    case subtitle(content: Label.Content)
    case qr(content: QRView.Content)
  }

  static let empty: Self = .init(sections: [])

  let sections: [Section]
}
