//
//  AuthorizationViewController.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import UIKit

final class AuthorizationViewController: UIViewController {
  
  var interactor: AuthorizationInteractorProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor?.viewDidLoad()
  }
}

// MARK: - AuthorizationViewControllerProtocol

extension AuthorizationViewController: AuthorizationViewControllerProtocol {
  
}
