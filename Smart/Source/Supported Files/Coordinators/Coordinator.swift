//
//  Coordinator.swift
//  Smart
//
//  Created by Aleksei Smirnov on 29.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

protocol Coordinator: class {
  
  /// Старт flow координатора (обычно старт какого - нибудь модуля приложения)
  func start()
}

/// Протокол координатора, который поддерживает обработку диплинков
protocol CoordinatorWithDeepLinkSupport: Coordinator {
  
  /// Обработка диплинка. Если не может обработать сам, передаст обработку либо childs либо parent.
  ///
  /// - Important:
  /// Если из parent передаем обработку в childs, то для них надо обязательно делать проверку canHandle, иначе может быть бесконечный цикл.
  /// И указать, что вызов сделан из parent (isCalledFromParent).
  ///
  /// - Parameters:
  ///     - deepLink: диплинк
  ///     - isCalledFromParent: вызван из родителя
  func handle(deepLink: DeepLinkOption, isCalledFromParent: Bool)
  
  /// Может ли обработать диплинк
  ///
  /// - Parameter deepLink: диплинк
  func canHandle(deepLink: DeepLinkOption) -> Bool
  
  ///  Установить родительский координатор, которой сможет обрабатывать диплинк
  func setParentCoordinator(_ coordinator: CoordinatorWithDeepLinkSupport)
}

extension CoordinatorWithDeepLinkSupport {
  
  func handle(deepLink: DeepLinkOption, isCalledFromParent: Bool = false) {
    handle(deepLink: deepLink, isCalledFromParent: isCalledFromParent)
  }
}

/// Протокол координатора,который поддерживает обработку пушей
protocol CoordinatorWithPushSupport {
  
  func handle(pushNotification: PushNotificationOption)
}

/// Протокол координатора, который поддерживает аналитику запуска приложения
protocol CoordinatorWithAnalyticsAppLaunchSupport {
  
  /// Факт старта приложения
  func trackStartApp()
  
  /// Факт возврата в приложение
  func trackResumeApp()
  
}

/// Протокол root координатора, у которого нет родителя, который отвечает за обработку диплинков, если текущие координаторы не могут обработать диплинк
protocol RootCoordinatorWithDeepLinkSupport {
  
  /// Может ли обработать диплинк сразу. По умолчанию нет.
  func canHandleNow(deepLink: DeepLinkOption) -> Bool
  
  /// Запомнить диплинку для поздней обработки
  func remember(deepLink: DeepLinkOption)
  
  /// Создать и запустить координатор, который сможет обработать диплинку
  func startCoordinator(for deepLink: DeepLinkOption)
}

/// Базовый координатор.
class BaseCoordinator: CoordinatorWithDeepLinkSupport {
  
  var childCoordinators: [CoordinatorWithDeepLinkSupport] = []
  weak var parentCoordinator: CoordinatorWithDeepLinkSupport?
  
  /// Может ли обработать диплинк самостоятельно. По умолчанию нет. Можно переопределить.
  open func canHandleBySelf(deepLink: DeepLinkOption) -> Bool {
    false
  }
  
  /// Самостоятельная обработка диплинка контроллером. Нужно переопределять, если canHandleBySelf может быть true
  open func handleBySelf(deepLink: DeepLinkOption) {
    fatalError("Необходимо переопределить.")
  }
  
  /// Добавить child координатор
  func addChild(coordinator: CoordinatorWithDeepLinkSupport) {
    
    for element in childCoordinators where element === coordinator {
      return
    }
    coordinator.setParentCoordinator(self)
    childCoordinators.append(coordinator)
  }
  
  /// Удалить child координатор
  func removeChild(coordinator: CoordinatorWithDeepLinkSupport?) {
    
    guard
      childCoordinators.isEmpty == false,
      let coordinator = coordinator else {
      return
    }
    
    for (index, element) in childCoordinators.enumerated() where element === coordinator {
      childCoordinators.remove(at: index)
      break
    }
  }
  
  /// Удалить все child координаторы
  func removeAllChildCoordinators() {
    childCoordinators.forEach { removeChild(coordinator: $0) }
  }
  
  // MARK: - CoordinatorWithDeepLinkSupport
  
  func start() {}
  
  final func handle(deepLink: DeepLinkOption, isCalledFromParent: Bool) {
    
    // если может обработать сам
    if canHandleBySelf(deepLink: deepLink) {
      handleBySelf(deepLink: deepLink)
      return
    }
    
    // пытаемся найти среди childCoordinators, координатор который может обработать
    for child in childCoordinators {
      if child.canHandle(deepLink: deepLink) {
        child.handle(deepLink: deepLink, isCalledFromParent: true)
        return
      }
    }
    
    // если родителя нет, то надо создать координатор, который может обработать диплинку и запустить его
    if
      let rootCoordinator = self as? RootCoordinatorWithDeepLinkSupport,
      parentCoordinator == nil {
      
      if rootCoordinator.canHandleNow(deepLink: deepLink) {
        rootCoordinator.startCoordinator(for: deepLink)
      } else {
        rootCoordinator.remember(deepLink: deepLink)
      }
      return
    }
    
    // передаем обработку родителю, если сюда попали не из родителя
    guard let parentCoordinator = parentCoordinator, !isCalledFromParent else { return }
    parentCoordinator.handle(deepLink: deepLink)
  }
  
  /// Может ли обработать диплинк (сам или childCoordinators)
  final func canHandle(deepLink: DeepLinkOption) -> Bool {
    
    if canHandleBySelf(deepLink: deepLink) {
      return true
    }
    
    for child in childCoordinators where child.canHandle(deepLink: deepLink)  {
      return true
    }
    
    return false
  }
  
  final func setParentCoordinator(_ coordinator: CoordinatorWithDeepLinkSupport) {
    parentCoordinator = coordinator
  }
}

enum DeepLinkOption {
  case wineDetail(wineID: Int64)

  init?(url: URL?) {

    guard let url = url, !url.pathComponents.isEmpty else { return nil }
    if
      let word = url.pathComponents[safe: url.pathComponents.count - 2],
      word == "wines"
    {
      guard
        let id = url.pathComponents.last,
        let wineID = Int64(id) else { return nil }
      self = .wineDetail(wineID: wineID)
    }

    return nil
  }
}

enum PushNotificationOption {
  
}

protocol CoordinatorCloseDelegate: AnyObject {
  
  func didCloseCoordinator(_ coordinator: BaseCoordinator)
}
