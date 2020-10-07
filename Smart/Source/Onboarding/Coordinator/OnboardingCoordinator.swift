//
//  OnboardingCoordinator.swift
//  Smart
//
//  Created by Aleksei Smirnov on 30.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class OnboardingCoordinator: BaseCoordinator {

    // MARK: - Private Properties

    private let moduleFactory = OnboardingModuleFactory()
    private let navigationController: UINavigationController
    private lazy var agreementsViewController = moduleFactory.makeOnboardingViewController(delegate: self)
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

extension OnboardingCoordinator: OnboardingViewControllerOutput {
    func didFinishWathingOnboarding() {
        closeDelegate?.didCloseCoordinator(self)
    }
}
