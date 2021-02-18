//
//  ErrorView.swift
//  CommonUI
//
//  Created by Aleksei Smirnov on 18.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

public protocol ErrorViewDelegate: AnyObject {
  func didTapErrorButton(_ button: UIButton)
}

public struct ErrorViewModel: ViewModelProtocol {
  
  fileprivate let titleText: String?
  fileprivate let subtitleText: String?
  fileprivate let buttonText: String?
  
  public init(titleText: String?, subtitleText: String?, buttonText: String?) {
    
    self.titleText = titleText
    self.subtitleText = subtitleText
    self.buttonText = buttonText
  }
}

public final class ErrorView: UIView {
  
  // MARK: - Public Properties
  
  public weak var delegate: ErrorViewDelegate?
  
  // MARK: - Private Properties
  
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let button = UIButton()
  
  // MARK: - Initializers
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
        
    let spacer1 = UIView()
    
    let views = [
      titleLabel,
      subtitleLabel,
      spacer1,
      button,
    ]
    
    views.forEach({
      $0.translatesAutoresizingMaskIntoConstraints = false
    })
    
    titleLabel.font = Font.bold(24)
    titleLabel.textAlignment = .center
    titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - 40).isActive = true
    
    subtitleLabel.font = Font.medium(18)
    subtitleLabel.textColor = .blueGray
    subtitleLabel.textAlignment = .center
    subtitleLabel.numberOfLines = 3
    subtitleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - 40).isActive = true

    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = Font.bold(18)
    button.backgroundColor = .accent
    button.layer.cornerRadius = 24
    button.clipsToBounds = true
    button.heightAnchor.constraint(equalToConstant: 48).isActive = true
    button.widthAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
    button.addTarget(self, action: #selector(didTapErrorButton(_:)), for: .touchUpInside)
    
    spacer1.heightAnchor.constraint(equalToConstant: 5).isActive = true
    
    let stackView = UIStackView(arrangedSubviews: views)
    stackView.axis = .vertical
    
    stackView.distribution = .equalCentering
    stackView.spacing = 8
    stackView.alignment = .center
    stackView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
  // MARK: - Private Methods
  
  @objc
  private func didTapErrorButton(_ button: UIButton) {
    delegate?.didTapErrorButton(button)
  }
}

extension ErrorView: Decoratable {
  
  public typealias ViewModel = ErrorViewModel
  
  public func decorate(model: ViewModel) {
    
    titleLabel.text = model.titleText
    titleLabel.isHidden = model.titleText == nil
    
    subtitleLabel.text = model.subtitleText
    subtitleLabel.isHidden = model.subtitleText == nil
    
    button.setTitle(model.buttonText, for: .normal)
    button.isHidden = model.buttonText == nil
  }
}
