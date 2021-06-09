//
//  MapNavigationBarCollectionCell.swift
//  Smart
//
//  Created by Алексей Смирнов on 13.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display

protocol MapNavigationBarDelegate: AnyObject {
  func didTapLeadingButton(_ button: UIButton)
  func didTapTrailingButton(_ button: UIButton)
}

struct MapNavigationBarCollectionCellViewModel: ViewModelProtocol {
  init() { }
}

final class MapNavigationBarCollectionCell: UICollectionReusableView, Reusable {
  
  // MARK: - Internal Properties
  
  weak var delegate: MapNavigationBarDelegate?

  // MARK: - Private Properties
  
  private lazy var leadingButton: UIButton = {
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    $0.setImage(UIImage(systemName: "figure.walk", withConfiguration: imageConfig)?.withTintColor(.accent, renderingMode: .alwaysOriginal), for: .normal)
    $0.addTarget(self, action: #selector(didTapLeadingButton(_:)), for: .touchUpInside)
    return $0
  }(UIButton())
  
  private lazy var trailingButton: UIButton = {
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    $0.setImage(UIImage(systemName: "xmark", withConfiguration: imageConfig)?.withTintColor(.blueGray, renderingMode: .alwaysOriginal), for: .normal)
    $0.addTarget(self, action: #selector(didTapTrailingButton(_:)), for: .touchUpInside)
    return $0
  }(UIButton())
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
        
    addSubview(leadingButton)
    leadingButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      leadingButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
      leadingButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      leadingButton.widthAnchor.constraint(equalToConstant: 48),
      leadingButton.heightAnchor.constraint(equalToConstant: 48),
    ])
    
    addSubview(trailingButton)
    trailingButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      trailingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
      trailingButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      trailingButton.widthAnchor.constraint(equalToConstant: 48),
      trailingButton.heightAnchor.constraint(equalToConstant: 48),
    ])
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
  @objc
  private func didTapLeadingButton(_ button: UIButton) {
    delegate?.didTapLeadingButton(button)
  }
  
  @objc
  private func didTapTrailingButton(_ button: UIButton) {
    delegate?.didTapTrailingButton(button)
  }
}

// MARK: - Decoratable

extension MapNavigationBarCollectionCell: Decoratable {
  
  typealias ViewModel = MapNavigationBarCollectionCellViewModel
  
  func decorate(model: ViewModel) { }
}
