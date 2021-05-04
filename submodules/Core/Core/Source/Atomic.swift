//
//  Atomic.swift
//  Core
//
//  Created by Алексей Смирнов on 03.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

final
private class AtomicLock {
  private var _lock = os_unfair_lock()
  
  func lock() {
    os_unfair_lock_lock(&_lock)
  }
  
  func tryLock() -> Bool {
    os_unfair_lock_trylock(&_lock)
  }
  
  func unlock() {
    os_unfair_lock_unlock(&_lock)
  }
}

public struct AtomicOption: Equatable, OptionSet {
  public var rawValue: Int
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
  
  public static let asyncedRead: AtomicOption = .init(rawValue: 0)
  public static let syncedRead: AtomicOption = .init(rawValue: 1)
}

@propertyWrapper
public class Atomic<Value> {
  private let lock = AtomicLock()
  private var value: Value
  private let option: AtomicOption
  
  public var projectedValue: Atomic<Value> {
    return self
  }
  
  public var wrappedValue: Value {
    get {
      option.contains(.syncedRead) ? lock.lock() : ()
      
      defer {
        option.contains(.syncedRead) ? lock.unlock() : ()
      }
      
      return value
    }
    set {
      lock.lock()
      value = newValue
      lock.unlock()
    }
  }
  
  public init(wrappedValue initialValue: Value, option: AtomicOption = .asyncedRead) {
    self.value = initialValue
    self.option = option
  }
  
  public func mutate(_ mutation: (inout Value) -> Void) {
    lock.lock()
    mutation(&self.value)
    lock.unlock()
  }
  
  public func tryMutate(_ mutation: (inout Value) -> Void) {
    let locked = lock.tryLock()
    mutation(&self.value)
    if locked {
      lock.unlock()
    }
  }
  
  public func mutate<T>(_ mutation: (inout Value) -> T) -> T {
    lock.lock()
    let value = mutation(&self.value)
    lock.unlock()
    return value
  }
  
  public func tryMutate<T>(_ mutation: (inout Value) -> T) -> T {
    let locked = lock.tryLock()
    let value = mutation(&self.value)
    if locked {
      lock.unlock()
    }
    return value
  }
}

extension Atomic where Value: ExpressibleByNilLiteral {
  public convenience init(option: AtomicOption = .asyncedRead) {
    self.init(wrappedValue: nil, option: option)
  }
}
