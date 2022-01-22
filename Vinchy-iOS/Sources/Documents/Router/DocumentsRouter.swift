//
//  DocumentsRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 04.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - DocumentsRouter

final class DocumentsRouter {

  // MARK: Lifecycle

  init(viewController: UIViewController)
  {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: DocumentsInteractorProtocol?

}

// MARK: DocumentsRouterProtocol

extension DocumentsRouter: DocumentsRouterProtocol {

}
