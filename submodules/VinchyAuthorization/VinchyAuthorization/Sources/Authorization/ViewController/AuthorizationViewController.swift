//
//  AuthorizationViewController.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import UIKit
import Display

final class AuthorizationViewController: UIViewController {
  
  var interactor: AuthorizationInteractorProtocol?
  
  private let welcomeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .accent
    label.font = Font.heavy(48)
    label.text = "Welcome"
    label.numberOfLines = 0
    return label
  }()
  
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .dark
    label.font = Font.regular(20)
    label.text = "To start collect bottles your should authentificate yourself"
    label.numberOfLines = 0
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .mainBackground
    
    view.addSubview(welcomeLabel)
    welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
      welcomeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      welcomeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
    ])
    
    view.addSubview(descriptionLabel)
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      descriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8),
      descriptionLabel.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
      descriptionLabel.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor),
    ])
    
    interactor?.viewDidLoad()
  }
}

// MARK: - AuthorizationViewControllerProtocol

extension AuthorizationViewController: AuthorizationViewControllerProtocol {
  
}
