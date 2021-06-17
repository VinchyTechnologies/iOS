//
//  ViewController.swift
//  VinchyAuthorizationApp
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import UIKit
import VinchyAuthorization

// MARK: - ViewController

final class ViewController: UIViewController {

  // MARK: Internal

  override func viewDidLoad() {
    super.viewDidLoad()

    let button = UIButton()
    button.backgroundColor = .systemRed
    button.setTitle("Authorize", for: .normal)
    button.addTarget(self, action: #selector(didTapAuth(_:)), for: .touchUpInside)
    button.contentEdgeInsets = .init(top: 14, left: 18, bottom: 14, right: 18)
    button.layer.cornerRadius = 10
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .boldSystemFont(ofSize: 18)

    view.addSubview(button)
    button.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }

  // MARK: Private

  @objc
  private func didTapAuth(_: UIButton) {
    let viewController: AuthorizationNavigationController = ChooseAuthTypeAssembly.assemblyModule()
    viewController.authOutputDelegate = self
    present(viewController, animated: true, completion: nil)
  }
}

// MARK: AuthorizationOutputDelegate

extension ViewController: AuthorizationOutputDelegate {
  func didSuccessfullyRegister(output: AuthorizationOutputModel?) {
    print(#function)
    print(output as Any)
  }

  func didSuccessfullyLogin(output: AuthorizationOutputModel?) {
    print(#function)
    print(output as Any)
  }
}
