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

    case stories(content: FakeCollectionView.Content)
    case promo(content: FakeCollectionView.Content)
    case title(content: FakeCollectionView.Content)
    case big(content: FakeCollectionView.Content)

    // MARK: Internal

    enum DataID: Hashable {
      case title, stories, promo, big
    }

    var style: FakeCollectionView.Style {
      switch self {
      case .stories:
        return .init(kind: .mini)

      case .promo:
        return .init(kind: .promo)

      case .title:
        return .init(kind: .title)

      case .big:
        return .init(kind: .big)
      }
    }

    var dataID: DataID {
      switch self {
      case .stories:
        return .stories

      case .promo:
        return .promo

      case .title:
        return .title

      case .big:
        return .big
      }
    }
  }

  static let empty: Self = .init(state: .fake(sections: []), leadingAddressButtonViewModel: .loading(text: nil))

  let state: State
  let leadingAddressButtonViewModel: DiscoveryLeadingAddressButtonMode
}
