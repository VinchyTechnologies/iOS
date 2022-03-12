//
//  OptionsViewModel.swift
//  Questions
//
//  Created by Алексей Смирнов on 12.03.2022.
//

import DisplayMini

struct OptionsViewModel {
  let navigationTitle: String?
  let header: OptionHeader.Content
  let items: [Item]
  let bottomBarViewModel: BottomPriceBarView.Content?
  let isNextButtonEnabled: Bool

  enum Item {
    case common(content: OptionView.Content)
  }

  static let empty: Self = .init(navigationTitle: nil, header: .init(titleText: "", subtitleText: nil), items: [], bottomBarViewModel: nil, isNextButtonEnabled: false)
}
