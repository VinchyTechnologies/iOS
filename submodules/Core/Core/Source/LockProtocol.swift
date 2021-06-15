//
//  LockProtocol.swift
//  Core
//
//  Created by Алексей Смирнов on 09.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

// MARK: - LockProtocol

public protocol LockProtocol: AnyObject {
  func lock()
  func unlock()
}

// MARK: - NSLock + LockProtocol

extension NSLock: LockProtocol {}

// MARK: - NSConditionLock + LockProtocol

extension NSConditionLock: LockProtocol {}

// MARK: - NSRecursiveLock + LockProtocol

extension NSRecursiveLock: LockProtocol {}

// MARK: - NSCondition + LockProtocol

extension NSCondition: LockProtocol {}

extension LockProtocol {
  @discardableResult
  public func synchronized<T>(_ block: () -> T) -> T {
    lock()
    defer { unlock() }
    return block()
  }
}
