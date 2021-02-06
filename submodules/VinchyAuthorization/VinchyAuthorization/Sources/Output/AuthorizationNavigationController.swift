//
//  AuthorizationNavigationController.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 06.02.2021.
//

import Display
import UIKit

final class AuthorizationNavigationController: NavigationController {
  weak var authOutputDelegate: AuthorizationOutputDelegate?
}
