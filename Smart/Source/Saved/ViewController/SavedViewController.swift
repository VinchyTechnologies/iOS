//
//  SavedViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - SavedViewController

final class SavedViewController: UIViewController, SavedViewControllerProtocol {

  // MARK: Internal

  var interactor: SavedInteractorProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = "Saved"
    navigationItem.largeTitleDisplayMode = .never

    let pagingViewController = PagingViewController(viewControllers: viewControllers)

    addChild(pagingViewController)
    view.addSubview(pagingViewController.view)
    pagingViewController.didMove(toParent: self)
    pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      pagingViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
    ])
  }

  // MARK: Private

  private let viewControllers = [DocumentsAssembly.assemblyModule(), WineDetailAssembly.assemblyModule(input: .init(wineID: 891))]

  private lazy var pagingViewController: PagingViewController = {
    $0
  }(PagingViewController())
}
