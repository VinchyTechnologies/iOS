//
//  InMemoryRepository.swift
//  Database
//
//  Created by Алексей Берёзка on 12.03.2020.
//  Copyright © 2020 Dodo Pizza. All rights reserved.
//

import Foundation

open class InMemoryRepository<M>: CollectionRepository<M> where M: RepositoryItem {
  public init() {
    super.init(storage: InMemoryStorage().toAny())
  }
}
