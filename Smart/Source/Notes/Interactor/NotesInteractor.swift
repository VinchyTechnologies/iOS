//
//  NotesInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class NotesInteractor {

    private let router: NotesRouterProtocol
    private let presenter: NotesPresenterProtocol

    init(
        router: NotesRouterProtocol,
        presenter: NotesPresenterProtocol)
    {
        self.router = router
        self.presenter = presenter
    }
}

// MARK: - NotesInteractorProtocol

extension NotesInteractor: NotesInteractorProtocol {

    func viewDidLoad() {
        
    }
}
