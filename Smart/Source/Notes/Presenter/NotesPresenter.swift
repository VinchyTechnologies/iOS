//
//  NotesPresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class NotesPresenter {

    private typealias ViewModel = NotesViewModel

    weak var viewController: NotesViewControllerProtocol?

    init(viewController: NotesViewControllerProtocol) {
        self.viewController = viewController
    }
}

// MARK: - NotesPresenterProtocol

extension NotesPresenter: NotesPresenterProtocol {

}
