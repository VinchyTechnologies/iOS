//
//  NotesViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class NotesViewController: UIViewController {

    var interactor: NotesInteractorProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
}

// MARK: - NotesViewControllerProtocol

extension NotesViewController: NotesViewControllerProtocol {

}
