// The MIT License (MIT)
//
// Copyright (c) 2015-2021 Alexander Grebenyuk (github.com/kean).

import Foundation

// MARK: - Task

/// Represents a task with support for multiple observers, cancellation,
/// progress reporting, dependencies – everything that `ImagePipeline` needs.
///
/// A `Task` can have zero or more subscriptions (`TaskSubscription`) which can
/// be used to later unsubscribe or change the priority of the subscription.
///
/// The task has built-in support for operations (`Foundation.Operation`) – it
/// automatically cancels them, updates the priority, etc. Most steps in the
/// image pipeline are represented using Operation to take advantage of these features.
///
/// - warning: Must be thread-confined!
class Task<Value, Error>: TaskSubscriptionDelegate {

  // MARK: Lifecycle

  #if TRACK_ALLOCATIONS
  deinit {
    Allocations.decrement("Task")
  }

  init() {
    Allocations.increment("Task")
  }
  #endif

  // MARK: Internal

  /// Returns `true` if the task was either cancelled, or was completed.
  private(set) var isDisposed = false
  /// Gets called when the task is either cancelled, or was completed.
  var onDisposed: (() -> Void)?

  var onCancelled: (() -> Void)?

  /// A task might have a dependency. The task automatically unsubscribes
  /// from the dependency when it gets cancelled, and also updates the
  /// priority of the subscription to the dependency when its own
  /// priority is updated.
  var dependency: TaskSubscription? {
    didSet {
      dependency?.setPriority(priority)
    }
  }

  weak var operation: Foundation.Operation? {
    didSet {
      guard priority != .normal else { return }
      operation?.queuePriority = priority.queuePriority
    }
  }

  /// Publishes the results of the task.
  var publisher: Publisher { Publisher(task: self) }

  /// Override this to start image task. Only gets called once.
  func start() {}

  // MARK: - Sending Events

  func send(value: Value, isCompleted: Bool = false) {
    send(event: .value(value, isCompleted: isCompleted))
  }

  func send(error: Error) {
    send(event: .error(error))
  }

  func send(progress: TaskProgress) {
    send(event: .progress(progress))
  }

  // MARK: Fileprivate

  // MARK: - TaskSubscriptionDelegate

  fileprivate func setPriority(_ priority: TaskPriority, for key: TaskSubscriptionKey) {
    guard !isDisposed else { return }

    if key == 0 {
      inlineSubscription?.priority = priority
    } else {
      subscriptions![key]?.priority = priority
    }
    updatePriority(suggestedPriority: priority)
  }

  fileprivate func unsubsribe(key: TaskSubscriptionKey) {
    if key == 0 {
      guard inlineSubscription != nil else { return }
      inlineSubscription = nil
    } else {
      guard subscriptions!.removeValue(forKey: key) != nil else { return }
    }

    guard !isDisposed else { return }

    if inlineSubscription == nil && subscriptions?.isEmpty ?? true {
      terminate(reason: .cancelled)
    } else {
      updatePriority(suggestedPriority: nil)
    }
  }

  // MARK: Private

  private struct Subscription {
    let observer: (Event) -> Void
    var priority: TaskPriority
  }

  // MARK: - Termination

  private enum TerminationReason {
    case finished, cancelled
  }

  // In most situations, especially for intermediate tasks, the almost almost
  // only one subscription.
  private var inlineSubscription: Subscription?
  private var subscriptions: [TaskSubscriptionKey: Subscription]? // Create lazily
  private var nextSubscriptionKey = 0

  private var isStarted = false

  private var priority: TaskPriority = .normal {
    didSet {
      guard oldValue != priority else { return }
      operation?.queuePriority = priority.queuePriority
      dependency?.setPriority(priority)
    }
  }

  // MARK: - Managing Observers

  /// - notes: Returns `nil` if the task was disposed.
  private func subscribe(priority: TaskPriority = .normal, _ observer: @escaping (Event) -> Void) -> TaskSubscription? {
    guard !isDisposed else { return nil }

    let subscriptionKey = nextSubscriptionKey
    nextSubscriptionKey += 1
    let subscription = TaskSubscription(task: self, key: subscriptionKey)

    if subscriptionKey == 0 {
      inlineSubscription = Subscription(observer: observer, priority: priority)
    } else {
      if subscriptions == nil { subscriptions = [:] }
      subscriptions![subscriptionKey] = Subscription(observer: observer, priority: priority)
    }

    updatePriority(suggestedPriority: priority)

    if !isStarted {
      isStarted = true
      start()
    }

    // The task may have been completed synchronously by `starter`.
    guard !isDisposed else { return nil }

    return subscription
  }

  private func send(event: Event) {
    guard !isDisposed else { return }

    switch event {
    case .value(_, let isCompleted):
      if isCompleted {
        terminate(reason: .finished)
      }
    case .progress:
      break // Simply send the event
    case .error:
      terminate(reason: .finished)
    }

    inlineSubscription?.observer(event)
    if let subscriptions = subscriptions {
      for subscription in subscriptions.values {
        subscription.observer(event)
      }
    }
  }

  private func terminate(reason: TerminationReason) {
    guard !isDisposed else { return }
    isDisposed = true

    if reason == .cancelled {
      operation?.cancel()
      dependency?.unsubscribe()
      onCancelled?()
    }
    onDisposed?()
  }

  // MARK: - Priority

  private func updatePriority(suggestedPriority: TaskPriority?) {
    if let suggestedPriority = suggestedPriority, suggestedPriority >= priority {
      // No need to recompute, won't go higher than that
      priority = suggestedPriority
      return
    }

    var newPriority = inlineSubscription?.priority
    // Same as subscriptions.map { $0?.priority }.max() but without allocating
    // any memory for redundant arrays
    if let subscriptions = subscriptions {
      for subscription in subscriptions.values {
        if newPriority == nil {
          newPriority = subscription.priority
        } else if subscription.priority > newPriority! {
          newPriority = subscription.priority
        }
      }
    }
    priority = newPriority ?? .normal
  }
}

// MARK: - Task (Publisher)

extension Task {
  /// Publishes the results of the task.
  struct Publisher {

    // MARK: Internal

    /// Attaches the subscriber to the task.
    /// - notes: Returns `nil` if the task is already disposed.
    func subscribe(priority: TaskPriority = .normal, _ observer: @escaping (Event) -> Void) -> TaskSubscription? {
      task.subscribe(priority: priority, observer)
    }

    /// Attaches the subscriber to the task. Automatically forwards progress
    /// andd error events to the given task.
    /// - notes: Returns `nil` if the task is already disposed.
    func subscribe<NewValue>(_ task: Task<NewValue, Error>, onValue: @escaping (Value, Bool) -> Void) -> TaskSubscription? {
      subscribe { [weak task] event in
        guard let task = task else { return }
        switch event {
        case .value(let value, let isCompleted):
          onValue(value, isCompleted)
        case .progress(let progress):
          task.send(progress: progress)
        case .error(let error):
          task.send(error: error)
        }
      }
    }

    // MARK: Fileprivate

    fileprivate let task: Task

  }
}

// MARK: - TaskProgress

struct TaskProgress: Hashable {
  let completed: Int64
  let total: Int64
}

// MARK: - TaskPriority

enum TaskPriority: Int, Comparable {
  case veryLow = 0, low, normal, high, veryHigh

  var queuePriority: Operation.QueuePriority {
    switch self {
    case .veryLow: return .veryLow
    case .low: return .low
    case .normal: return .normal
    case .high: return .high
    case .veryHigh: return .veryHigh
    }
  }

  static func < (lhs: TaskPriority, rhs: TaskPriority) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

// MARK: - Task.Event {
extension Task {
  enum Event {
    case value(Value, isCompleted: Bool)
    case progress(TaskProgress)
    case error(Error)

    var isCompleted: Bool {
      switch self {
      case .value(_, let isCompleted): return isCompleted
      case .progress: return false
      case .error: return true
      }
    }
  }
}

// MARK: - Task.Event + Equatable

extension Task.Event: Equatable where Value: Equatable, Error: Equatable {}

// MARK: - TaskSubscription

/// Represents a subscription to a task. The observer must retain a strong
/// reference to a subscription.
struct TaskSubscription {

  // MARK: Lifecycle

  fileprivate init(task: TaskSubscriptionDelegate, key: TaskSubscriptionKey) {
    self.task = task
    self.key = key
  }

  // MARK: Internal

  /// Removes the subscription from the task. The observer won't receive any
  /// more events from the task.
  ///
  /// If there are no more subscriptions attached to the task, the task gets
  /// cancelled along with its dependencies. The cancelled task is
  /// marked as disposed.
  func unsubscribe() {
    task.unsubsribe(key: key)
  }

  /// Updates the priority of the subscription. The priority of the task is
  /// calculated as the maximum priority out of all of its subscription. When
  /// the priority of the task is updated, the priority of a dependency also is.
  ///
  /// - note: The priority also automatically gets updated when the subscription
  /// is removed from the task.
  func setPriority(_ priority: TaskPriority) {
    task.setPriority(priority, for: key)
  }

  // MARK: Private

  private let task: TaskSubscriptionDelegate
  private let key: TaskSubscriptionKey

}

// MARK: - TaskSubscriptionDelegate

private protocol TaskSubscriptionDelegate: AnyObject {
  func unsubsribe(key: TaskSubscriptionKey)
  func setPriority(_ priority: TaskPriority, for observer: TaskSubscriptionKey)
}

private typealias TaskSubscriptionKey = Int

// MARK: - TaskPool

/// Contains the tasks which haven't completed yet.
final class TaskPool<Key: Hashable, Value, Error> {

  // MARK: Lifecycle

  init(_ isDeduplicationEnabled: Bool) {
    self.isDeduplicationEnabled = isDeduplicationEnabled
  }

  // MARK: Internal

  /// Creates a task with the given key. If there is an outstanding task with
  /// the given key in the pool, the existing task is returned. Tasks are
  /// automatically removed from the pool when they are disposed.
  func publisherForKey(_ key: Key, _ make: () -> Task<Value, Error>) -> Task<Value, Error>.Publisher {
    guard isDeduplicationEnabled else {
      return make().publisher
    }
    if let task = map[key] {
      return task.publisher
    }
    let task = make()
    map[key] = task
    task.onDisposed = { [weak self] in
      self?.map[key] = nil
    }
    return task.publisher
  }

  // MARK: Private

  private let isDeduplicationEnabled: Bool
  private var map = [Key: Task<Value, Error>]()

}
