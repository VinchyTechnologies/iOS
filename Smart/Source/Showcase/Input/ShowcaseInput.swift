//
//  ShowcaseInput.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 4/5/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import VinchyCore

// MARK: - ShowcaseInput

struct ShowcaseInput {
  let title: String?
  let mode: ShowcaseMode
}

// MARK: - ShowcaseMode

enum ShowcaseMode {
  case normal(wines: [ShortWine])
  case advancedSearch(params: [(String, String)])
  case partner(partnerID: Int, affilatedID: Int)
}
