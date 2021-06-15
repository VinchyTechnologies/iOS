//
//  EditProfileRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 15.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class EditProfileRouter {

    weak var viewController: UIViewController?
    weak var interactor: EditProfileInteractorProtocol?
    private let input: EditProfileInput

    init(
        input: EditProfileInput,
        viewController: UIViewController)
    {
        self.input = input
        self.viewController = viewController
    }
}

// MARK: - EditProfileRouterProtocol

extension EditProfileRouter: EditProfileRouterProtocol {

}
