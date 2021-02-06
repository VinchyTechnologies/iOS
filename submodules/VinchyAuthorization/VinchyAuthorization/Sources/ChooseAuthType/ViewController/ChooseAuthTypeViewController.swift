//
//  ChooseAuthTypeViewController.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 05.02.2021.
//

import UIKit
import Display

final class ChooseAuthTypeViewController: UIViewController {
  
  var interactor: ChooseAuthTypeInteractorProtocol?
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .accent
    label.font = Font.heavy(48)
    label.numberOfLines = 0
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .dark
    label.font = Font.regular(20)
    label.numberOfLines = 0
    return label
  }()
  
  private lazy var registerButton: Button = {
    let button = Button()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.enable()
    button.addTarget(self, action: #selector(didTapRegisterButton(_:)), for: .touchUpInside)
    return button
  }()

  private lazy var loginButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .clear
    button.setTitleColor(.accent, for: .normal)
    button.titleLabel?.font = Font.bold(18)
    button.clipsToBounds = true
    button.layer.cornerCurve = .continuous
    button.layer.cornerRadius = 24
    button.layer.borderWidth = 2
    button.layer.borderColor = UIColor.accent.cgColor
    button.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.largeTitleDisplayMode = .never
    
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "xmark", withConfiguration: imageConfig),
      style: .plain,
      target: self,
      action: #selector(closeSelf))
    
    view.backgroundColor = .mainBackground
    
    titleLabel.text = "Welcome"
    subtitleLabel.text = "Needs to auth yourself"
    
    view.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
      titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
    ])
    
    view.addSubview(subtitleLabel)
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
      subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
    ])
    
    view.addSubview(loginButton)
    loginButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
      loginButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      loginButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
      loginButton.heightAnchor.constraint(equalToConstant: 48),
    ])
    
    view.addSubview(registerButton)
    registerButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      registerButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -8),
      registerButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      registerButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
      registerButton.heightAnchor.constraint(equalToConstant: 48),
    ])
    
    interactor?.viewDidLoad()
    
  }
  
  @objc
  private func closeSelf() {
    dismiss(animated: true)
  }
  
  @objc
  private func didTapRegisterButton(_ button: UIButton) {
    interactor?.didTapRegisterButton()
  }
  
  @objc
  private func didTapLoginButton(_ button: UIButton) {
    interactor?.didTapLoginButton()
  }
}

// MARK: - ChooseAuthTypeViewControllerProtocol

extension ChooseAuthTypeViewController: ChooseAuthTypeViewControllerProtocol {
  func updateUI(viewModel: ChooseAuthTypeViewModel) {
    titleLabel.text = viewModel.titleText
    subtitleLabel.text = viewModel.subtitleText
    loginButton.setTitle(viewModel.loginButtonText, for: .normal)
    registerButton.setTitle(viewModel.registerButtonText, for: .normal)
  }
}
