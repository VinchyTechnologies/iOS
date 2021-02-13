//
//  ChooseAuthTypeViewController.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 05.02.2021.
//

import UIKit
import Display
import StringFormatting

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
  
  private lazy var subtitleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .blueGray
    label.font = Font.regular(16)
    label.numberOfLines = 0
    
    let text = localized("agree_terms_of_use", bundle: Bundle(for: type(of: self)))
    label.text = text
    let underlineAttriString = NSMutableAttributedString(string: text)
    let range1 = (text as NSString).range(of: localized("terms_of_use", bundle: Bundle(for: type(of: self))))
    underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
    underlineAttriString.addAttribute(NSAttributedString.Key.font, value: Font.medium(16), range: range1)
    underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.accent, range: range1)
    label.attributedText = underlineAttriString
    
    label.isUserInteractionEnabled = true
    label.lineBreakMode = .byWordWrapping
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_:)))
    tapGesture.numberOfTouchesRequired = 1
    label.addGestureRecognizer(tapGesture)
    
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
  
  @objc
  private func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
    guard let text = subtitleLabel.text else { return }
    let emailRange = (text as NSString).range(of: localized("terms_of_use", bundle: Bundle(for: type(of: self))))
    if gesture.didTapAttributedTextInLabel(label: subtitleLabel, inRange: emailRange) {
      openTerms()
    }
  }
  
  private func openTerms() {
    open(urlString: localized("terms_of_use_url", bundle: Bundle(for: type(of: self))), errorCompletion: {
      showAlert(title: localized("error").firstLetterUppercased(), message: localized("open_url_error"))
    })
  }
}

// MARK: - ChooseAuthTypeViewControllerProtocol

extension ChooseAuthTypeViewController: ChooseAuthTypeViewControllerProtocol {
  func updateUI(viewModel: ChooseAuthTypeViewModel) {
    titleLabel.text = viewModel.titleText
//    subtitleLabel.text = viewModel.subtitleText
    loginButton.setTitle(viewModel.loginButtonText, for: .normal)
    registerButton.setTitle(viewModel.registerButtonText, for: .normal)
  }
}
