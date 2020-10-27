//
//  ApplicationModulesFactory.swift
//  Smart
//
//  Created by Aleksei Smirnov on 29.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

protocol ApplicationModulesFactory {

    func buildAgreementsCoordinator(
        rootViewController: UINavigationController,
        closeDelegate: CoordinatorCloseDelegate?)
        -> AgreementsCoordinator

    func buildAOnboardingCoordinator(
        rootViewController: UINavigationController,
        closeDelegate: CoordinatorCloseDelegate?)
        -> OnboardingCoordinator

    func buildMainCoordinator() -> MainCoordinator
}

final class ApplicationModulesFactoryImplementation {

    // MARK: - Private properties

    private let window: UIWindow

    // MARK: - Initializers

    init(window: UIWindow) {
        self.window = window
    }
}

extension ApplicationModulesFactoryImplementation: ApplicationModulesFactory {

    func buildAgreementsCoordinator(
        rootViewController: UINavigationController,
        closeDelegate: CoordinatorCloseDelegate?)
        -> AgreementsCoordinator
    {
        AgreementsCoordinator(navigationController: rootViewController, closeDelegate: closeDelegate)
    }

    func buildAOnboardingCoordinator(
        rootViewController: UINavigationController,
        closeDelegate: CoordinatorCloseDelegate?)
        -> OnboardingCoordinator {
        OnboardingCoordinator(navigationController: rootViewController, closeDelegate: closeDelegate)
    }

    func buildMainCoordinator() -> MainCoordinator {
        MainCoordinator(window: window)
    }
}
