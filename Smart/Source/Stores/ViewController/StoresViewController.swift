//
//  StoresViewController.swift
//  Smart
//
//  Created by Михаил Исаченко on 08.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - StoresViewController

final class StoresViewController: UIViewController {
  var interactor: StoresInteractorProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()
    interactor?.viewDidLoad()
  }
}

// MARK: StoresViewControllerProtocol

extension StoresViewController: StoresViewControllerProtocol {}
