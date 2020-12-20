//
//  ShareUsCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 07.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display
import StringFormatting

public struct ShareUsCollectionCellViewModel: ViewModelProtocol, Hashable {
  
  fileprivate let titleText: String?
  
  public init(titleText: String?) {
    self.titleText = titleText
  }
  
}

protocol ShareUsCollectionCellDelegate: AnyObject {
  func didTapShareUs(_ button: UIButton)
}

final class ShareUsCollectionCell: UICollectionViewCell, Reusable {
  
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let button = UIButton()
  
  weak var delegate: ShareUsCollectionCellDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .option //.mainBackground
    
    layer.cornerRadius = 24
    clipsToBounds = true
    layer.masksToBounds = false
    
    let stackView = UIStackView()
    stackView.alignment = .center
    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    
    titleLabel.font = Font.with(size: 24, design: .round, traits: .bold)
    titleLabel.textColor = .dark
    
    subtitleLabel.text = localized("tell_the_whole_world_about_us") 
    subtitleLabel.font = Font.bold(18)
    subtitleLabel.textColor = .blueGray
    
    button.backgroundColor = .accent
    button.translatesAutoresizingMaskIntoConstraints = false
    button.heightAnchor.constraint(equalToConstant: 48).isActive = true
    button.widthAnchor.constraint(equalToConstant: 240).isActive = true // TODO: - adaptive
    button.setTitle(localized("share_link").firstLetterUppercased(), for: .normal)
    button.titleLabel?.font = Font.bold(20)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 24
    button.clipsToBounds = true
    button.addTarget(self, action: #selector(didTapShareUs(_:)), for: .touchUpInside)
    
    [titleLabel, subtitleLabel].forEach({ $0.numberOfLines = 0 })
    
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(subtitleLabel)
    stackView.addArrangedSubview(button)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
    ])
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
  @objc
  func didTapShareUs(_ button: UIButton) {
    delegate?.didTapShareUs(button)
  }
  
}

extension ShareUsCollectionCell: Decoratable {
  
  typealias ViewModel = ShareUsCollectionCellViewModel
  
  func decorate(model: ViewModel) {
    self.titleLabel.text = model.titleText
  }
}
