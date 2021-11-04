//
//  SavedViewModel.swift
//  Smart
//
//  Created by Алексей Смирнов on 03.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display

struct SavedViewModel {

  enum Section {
    case liked
//    case rates(content: Any)
  }

  let sections: [Section]
  let navigationTitleText: String?
  let topTabBarViewModel: TopTabBarView.Content

  static let empty: Self = .init(sections: [], navigationTitleText: nil, topTabBarViewModel: .init(items: [], initiallySelectedIndex: 0))
}
