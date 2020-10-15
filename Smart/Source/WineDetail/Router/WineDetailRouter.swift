//
//  WineDetailRouter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class WineDetailRouter {

    weak var viewController: UIViewController?
    weak var interactor: WineDetailInteractorProtocol?
    private let input: WineDetailInput

    init(
        input: WineDetailInput,
        viewController: UIViewController)
    {
        self.input = input
        self.viewController = viewController
    }
}

// MARK: - WineDetailRouterProtocol

extension WineDetailRouter: WineDetailRouterProtocol {

}
