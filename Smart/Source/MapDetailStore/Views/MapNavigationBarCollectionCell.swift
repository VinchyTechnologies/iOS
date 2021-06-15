//
//  MapNavigationBarCollectionCell.swift
//  Smart
//
//  Created by Алексей Смирнов on 13.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display

// MARK: - MapNavigationBarDelegate

protocol MapNavigationBarDelegate: AnyObject {
  func didTapLeadingButton(_ button: UIButton)
  func didTapTrailingButton(_ button: UIButton)
}

// MARK: - MapNavigationBarCollectionCellViewModel

struct MapNavigationBarCollectionCellViewModel: ViewModelProtocol {
  init() {}
}

// MARK: - MapNavigationBarCollectionCell

final class MapNavigationBarCollectionCell: UICollectionReusableView, Reusable {

  // MARK: Lifecycle

  // MARK: - Initializers

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .mainBackground

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

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Internal

  // MARK: - Internal Properties

  weak var delegate: MapNavigationBarDelegate?

  // MARK: Private

  // MARK: - Private Properties

  private lazy var leadingButton: UIButton = {
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)

    if #available(iOS 14.0, *) {
      $0.setImage(UIImage(systemName: "figure.walk", withConfiguration: imageConfig)?.withTintColor(.accent, renderingMode: .alwaysOriginal), for: .normal)
    } else {
      $0.setImage(UIImage(named: "figureWalk")?.withTintColor(.accent, renderingMode: .alwaysOriginal), for: .normal)
      $0.imageView?.contentMode = .scaleAspectFit
      $0.imageEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
    }

    $0.addTarget(self, action: #selector(didTapLeadingButton(_:)), for: .touchUpInside)
    return $0
  }(UIButton())

  private lazy var trailingButton: UIButton = {
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    $0.setImage(UIImage(systemName: "xmark", withConfiguration: imageConfig)?.withTintColor(.blueGray, renderingMode: .alwaysOriginal), for: .normal)
    $0.addTarget(self, action: #selector(didTapTrailingButton(_:)), for: .touchUpInside)
    return $0
  }(UIButton())

  @objc
  private func didTapLeadingButton(_ button: UIButton) {
    delegate?.didTapLeadingButton(button)
  }

  @objc
  private func didTapTrailingButton(_ button: UIButton) {
    delegate?.didTapTrailingButton(button)
  }
}

// MARK: Decoratable

extension MapNavigationBarCollectionCell: Decoratable {
  typealias ViewModel = MapNavigationBarCollectionCellViewModel

  func decorate(model _: ViewModel) {}
}
