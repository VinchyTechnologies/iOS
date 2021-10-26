//
//  VinchyViewControllerViewModel.swift
//  Smart
//
//  Created by Aleksei Smirnov on 08.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI

struct VinchyViewControllerViewModel {

  enum State {
    case fake(sections: [FakeSection])
    case normal(sections: [Section])
  }

  enum Section {
    case title(content: Label.Content)
    case stories(content: [StoryView.Content])
    case commonSubtitle(content: [MainSubtitleView.Content], style: BigCollectionView.Style)
    case bottles(content: [WineBottleView.Content])
    case shareUs(content: ShareUsView.Content)
    case storeTitle(content: StoreTitleView.Content)
    case nearestStoreTitle(content: Label.Content)
    case harmfullToYourHealthTitle(content: Label.Content)
  }

  enum FakeSection {
    case stories(content: FakeVinchyCollectionCellViewModel)
    case promo(content: FakeVinchyCollectionCellViewModel)
    case title(content: FakeVinchyCollectionCellViewModel)
    case big(content: FakeVinchyCollectionCellViewModel)
  }

  static let empty: Self = .init(state: .fake(sections: []), leadingAddressButtonViewModel: .loading(text: nil))

  let state: State
  let leadingAddressButtonViewModel: DiscoveryLeadingAddressButtonMode
}
