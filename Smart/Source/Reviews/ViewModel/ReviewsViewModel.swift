//
//  ReviewsViewModel.swift
//  Smart
//
//  Created by Алексей Смирнов on 20.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI

struct ReviewsViewModel {
  enum State {
    case fake(sections: [FakeSection])
    case normal(items: [Item])
  }

  enum Item {
    case review(ReviewCellViewModel)
    case loading
  }

  enum FakeSection {
    case review([Any])
  }

  let state: State
  let navigationTitle: String?
}
