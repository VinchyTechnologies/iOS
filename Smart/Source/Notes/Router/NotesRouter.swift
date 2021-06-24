//
//  NotesRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class NotesRouter {

    weak var viewController: UIViewController?
    weak var interactor: NotesInteractorProtocol?
    private let input: NotesInput

    init(
        input: NotesInput,
        viewController: UIViewController)
    {
        self.input = input
        self.viewController = viewController
    }
}

// MARK: - NotesRouterProtocol

extension NotesRouter: NotesRouterProtocol {

}
