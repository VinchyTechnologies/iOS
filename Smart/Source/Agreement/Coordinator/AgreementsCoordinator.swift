//
//  AgreementsCoordinator.swift
//  Smart
//
//  Created by Aleksei Smirnov on 29.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class AgreementsCoordinator: BaseCoordinator {
  
  // MARK: - Private Properties
  
  private let moduleFactory = AgreementsModuleFactory()
  private let navigationController: UINavigationController
  private lazy var agreementsViewController = moduleFactory.makeAgreementsViewController(delegate: self)
  private weak var closeDelegate: CoordinatorCloseDelegate?
  
  // MARK: - Initializers
  
  init(navigationController: UINavigationController,
       closeDelegate: CoordinatorCloseDelegate?) {
    
    self.navigationController = navigationController
    self.closeDelegate = closeDelegate
  }
  
  // MARK: - Public Methods
  
  override func start() {
    navigationController.setViewControllers([agreementsViewController], animated: true)
  }
}

extension AgreementsCoordinator: AgreementsViewControllerOutput {
  
  func didConfirmAgeAndAgreement() {
    closeDelegate?.didCloseCoordinator(self)
  }
}
