//
//  SearchViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 01.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - SearchViewController

final class SearchViewController: UIViewController {

  var interactor: SearchInteractorProtocol?


  override func viewDidLoad() {
    super.viewDidLoad()
    interactor?.viewDidLoad()
  }
}

// MARK: SearchViewControllerProtocol

extension SearchViewController: SearchViewControllerProtocol {

}
