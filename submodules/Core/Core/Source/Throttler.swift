//
//  Throttler.swift
//  Core
//
//  Created by Алексей Смирнов on 05.01.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

// MARK: - ThrottlerProtocol

public protocol ThrottlerProtocol: AnyObject {
  var hasJob: Bool { get }
  func throttle(delay: DispatchTimeInterval, block: @escaping () -> Void)
  func cancel()
}

// MARK: - Throttler

public final class Throttler: ThrottlerProtocol {

  // MARK: Lifecycle

  public init(queue: DispatchQueue = .main) {
    self.queue = queue
  }

  // MARK: Public

  public var label: String?

  public var hasJob: Bool {
    guard let job = job else {
      return false
    }

    return Date().timeIntervalSince(job.performingDate) < .zero
  }

  public func throttle(delay: DispatchTimeInterval, block: @escaping () -> Void) {
    guard let timeInterval = delay.timeInterval else { return }
    let job = Job(
      workItem: DispatchWorkItem(block: block),
      performingDate: Date(timeInterval: timeInterval, since: Date()))
    self.job?.workItem.cancel()
    self.job = job
    queue.asyncAfter(deadline: .now() + delay, execute: job.workItem)
  }

  public func cancel() {
    job?.workItem.cancel()
  }

  // MARK: Private

  private struct Job {
    let workItem: DispatchWorkItem
    let performingDate: Date
  }

  private let queue: DispatchQueue
  private var job: Job?
}

extension DispatchTimeInterval {
  fileprivate var timeInterval: TimeInterval? {
    switch self {
    case .never:
      return nil

    case .seconds(let value):
      return TimeInterval(value)

    case .milliseconds(let value):
      return TimeInterval(value) / 1000

    case .microseconds(let value):
      return TimeInterval(value) / 1_000_000

    case .nanoseconds(let value):
      return TimeInterval(value) / 1_000_000_000

    @unknown default:
      return nil
    }
  }
}
