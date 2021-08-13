//
//  WorkItem.swift
//  Core
//
//  Created by Aleksei Smirnov on 19.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "Use Throttler") // TODO: - remove me
public final class WorkItem {

  // MARK: Lifecycle

  public init() {}

  // MARK: Public

  public func perform(after: TimeInterval, _ block: @escaping () -> Void) {
    pendingRequestWorkItem?.cancel()

    let requestWorkItem = DispatchWorkItem(block: block)

    pendingRequestWorkItem = requestWorkItem
    DispatchQueue.main.asyncAfter(deadline: .now() + after, execute: requestWorkItem)
  }

  // MARK: Private

  private var pendingRequestWorkItem: DispatchWorkItem?
}
