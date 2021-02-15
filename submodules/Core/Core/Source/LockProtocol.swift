//
//  LockProtocol.swift
//  Core
//
//  Created by Алексей Смирнов on 09.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

public protocol LockProtocol: AnyObject {
  func lock()
  func unlock()
}

extension NSLock: LockProtocol { }
extension NSConditionLock: LockProtocol { }
extension NSRecursiveLock: LockProtocol { }
extension NSCondition: LockProtocol { }

public extension LockProtocol {
  @discardableResult
  func synchronized<T>(_ block: () -> T) -> T {
    lock()
    defer { unlock() }
    return block()
  }
}
