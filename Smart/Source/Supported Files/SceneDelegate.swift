//
//  SceneDelegate.swift
//  Smart
//
//  Created by Aleksei Smirnov on 03.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks
import Display
import Database
import CoreData

final class SceneDelegate: UIResponder {
  
  // MARK: - Interanl Properties
  
  var window: UIWindow?
  
  // MARK: - Private Properties
    
  private lazy var root: (RootInteractor & RootDeeplinkable) = {
    RootBuilderImpl(tabBarBuilder: TabBarBuilderImpl())
      .build(input: RootBuilderInput(window: window!)) // swiftlint:disable:this force_unwrapping
  }()

  private lazy var deeplinkRouter: DeeplinkRouter = {
      DeeplinkRouterImpl(root: root)
  }()
}

extension SceneDelegate: UIWindowSceneDelegate {
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions)
  {
//    let db = CoreDatabase<CDWine>()
//    let entity = CDWine(context: db.persistentContainer.viewContext)
//    entity.setValues(wineID: 123, title: "titl")
//    
//    let review = CDReview(context: db.persistentContainer.viewContext)
//    review.setValues(estimation: .like, noteText: "lala", wine: entity)
//    db.saveContext()
//    
//    let wines = db.fetchAll(entityName: "CDWine")
//    let isEm = db.isEmpty(entityName: "CDWine")
//    print("============")
//    print(wines, isEm)
//    print("============")
    
    guard let windowScence = scene as? UIWindowScene else { return }
    
    let window = UIWindow(windowScene: windowScence)
    self.window = window
    root.startApp()

    if let userActivity = connectionOptions.userActivities.first {
      self.scene(scene, continue: userActivity)
    } else {
      self.scene(scene, openURLContexts: connectionOptions.urlContexts)
    }
  }

  func scene(
    _ scene: UIScene,
    continue userActivity: NSUserActivity)
  {
    usleep(50000)
    if let incomingURL = userActivity.webpageURL {
      DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
        guard error == nil, let dynamicLink = dynamicLink else { return }
        self.handleIncomingDynamicLink(dynamicLink)
      }
    }
  }

  func scene(
    _ scene: UIScene,
    openURLContexts URLContexts: Set<UIOpenURLContext>)
  {
    guard let urlToOpen = URLContexts.first?.url else { return }
    if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: urlToOpen) {
      handleIncomingDynamicLink(dynamicLink)
    }
  }

  private func handleIncomingDynamicLink(_ dynamicLink: DynamicLink) {
    guard
      let url = dynamicLink.url,
      (dynamicLink.matchType == .unique || dynamicLink.matchType == .default)
    else { return }
    
    self.deeplinkRouter.route(url: url)
  }
}
