//
//  Throttler.swift
//  Core
//
//  Created by Алексей Смирнов on 05.01.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

public protocol ThrottlerProtocol: class {
  
  var hasJob: Bool { get }
  
  func throttle(delay: DispatchTimeInterval, block: @escaping () -> Void)
  func cancel()
  
}

public final class Throttler: ThrottlerProtocol {
  
  private struct Job {
    let workItem: DispatchWorkItem
    let performingDate: Date
  }
  
  public var hasJob: Bool {
    guard let job = job else {
      return false
    }
    
    return Date().timeIntervalSince(job.performingDate) < .zero
  }
  
  private let queue: DispatchQueue
  private var job: Job?
  
  public init(queue: DispatchQueue = .main) {
    self.queue = queue
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
  
}

private extension DispatchTimeInterval {
  
  var timeInterval: TimeInterval? {
    switch self {
    case .never:
      return nil
      
    case .seconds(let value):
      return TimeInterval(value)
    
    case .milliseconds(let value):
      return TimeInterval(value) / 1_000
    
    case .microseconds(let value):
      return TimeInterval(value) / 1_000_000
    
    case .nanoseconds(let value):
      return TimeInterval(value) / 1_000_000_000
    
    @unknown default:
      return nil
    }
  }
  
}
