//
//  RatesViewModel.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI

struct RatesViewModel {
  enum State {
//    case fake(sections: [FakeSection])
    case normal(items: [Item])
  }

  enum Item {
    case review(WineRateView.Content)
    case loading
  }

  enum FakeSection {
    case review([Any])
  }

  let state: State
  let navigationTitle: String?
}
