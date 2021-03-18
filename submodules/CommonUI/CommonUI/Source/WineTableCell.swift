//
//  WineTableCell.swift
//  CommonUI
//
//  Created by Aleksei Smirnov on 18.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

public struct WineTableCellViewModel: ViewModelProtocol {
  
  fileprivate let imageURL: URL?
  fileprivate let titleText: String
  fileprivate let subtitleText: String?
  
  public init(imageURL: URL?, titleText: String, subtitleText: String?) {
    self.imageURL = imageURL
    self.titleText = titleText
    self.subtitleText = subtitleText
  }
}

public final class WineTableCell: UITableViewCell, Reusable {
  
  private let hStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    return stackView
  }()
  
  private let twoLabelsView = TwoLabelsView()
  
  private let bottleImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    hStackView.addArrangedSubview(bottleImageView)
    hStackView.addArrangedSubview(twoLabelsView)
    hStackView.setCustomSpacing(20, after: bottleImageView)
    
    contentView.addSubview(hStackView)
    hStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      hStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
      hStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      hStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -15),
      hStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
    ])
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
  public override func traitCollectionDidChange(
    _ previousTraitCollection: UITraitCollection?)
  {
    super.traitCollectionDidChange(previousTraitCollection)
    updateAccessibility()
  }
  
  private func updateAccessibility() {
    if traitCollection.preferredContentSizeCategory > .extraLarge {
      bottleImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -30).isActive = true
      bottleImageView.heightAnchor.constraint(equalTo: bottleImageView.widthAnchor).isActive = true
      hStackView.axis = .vertical
    } else {
      bottleImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
      bottleImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
      hStackView.axis = .horizontal
    }
  }
}

extension WineTableCell: Decoratable {
  
  public typealias ViewModel = WineTableCellViewModel
  
  public func decorate(model: ViewModel) {
    bottleImageView.loadBottle(url: model.imageURL)
    twoLabelsView.titleLabel.text = model.titleText
    twoLabelsView.subtitleLabel.text = model.subtitleText
    updateAccessibility()
  }
}

final fileprivate class TwoLabelsView: UIView {
  
  fileprivate let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .title2).withWeight(.bold)
    label.numberOfLines = 2
    label.adjustsFontForContentSizeCategory = true
    return label
  }()

  fileprivate let subtitleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .body).withWeight(.medium)
    label.textColor = .blueGray
    label.numberOfLines = 2
    label.adjustsFontForContentSizeCategory = true
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
    
    addSubview(subtitleLabel)
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
      subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
    ])
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
}
