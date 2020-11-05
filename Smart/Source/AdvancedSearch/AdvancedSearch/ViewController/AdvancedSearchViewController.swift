//
//  AdvancedSearchViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class AdvancedSearchViewController: UIViewController {
  
  var interactor: AdvancedSearchInteractorProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor?.viewDidLoad()
  }
}

// MARK: - AdvancedSearchViewControllerProtocol

extension AdvancedSearchViewController: AdvancedSearchViewControllerProtocol {
  
}
