//
//  DismissRoutable.swift
//  Display
//
//  Created by Алексей Смирнов on 23.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

public protocol DismissRoutable: AnyObject {
  
  var viewController: UIViewController? { get }
  
  func dismiss(completion: (() -> Void)?)
}

public extension DismissRoutable {
  
  func dismiss(completion: (() -> Void)?) {
    viewController?.dismiss(animated: true, completion: completion)
  }
}
