//
//  AuthorizationInteractorProtocol.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import Foundation

protocol AuthorizationInteractorProtocol: AnyObject {
  func viewDidLoad()
  func didEnterTextIntoEmailTextField(_ email: String?)
  func didTapContinueButton(_ email: String?)
}
