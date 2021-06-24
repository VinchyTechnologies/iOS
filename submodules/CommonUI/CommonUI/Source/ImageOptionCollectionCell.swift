//
//  ImageOptionCollectionCell.swift
//  CommonUI
//
//  Created by Aleksei Smirnov on 27.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - ImageOptionCollectionCellViewModel

public struct ImageOptionCollectionCellViewModel: ViewModelProtocol {
  fileprivate let image: UIImage?
  fileprivate let titleText: String?
  fileprivate let isSelected: Bool

  public init(image: UIImage?, titleText: String?, isSelected: Bool) {
    self.image = image
    self.titleText = titleText
    self.isSelected = isSelected
  }
}

// MARK: - ImageOptionCollectionCell

public final class ImageOptionCollectionCell: HighlightCollectionCell, Reusable {

  // MARK: Lifecycle

  override public init(frame: CGRect) {
    super.init(frame: frame)

    highlightStyle = .scale

    backgroundColor = .option
    layer.cornerRadius = 15
    clipsToBounds = true

    [imageView, titleLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

    titleLabel.font = Font.with(size: 20, design: .round, traits: .bold)
    titleLabel.textColor = .dark

    imageView.tintColor = .dark

    addSubview(imageView)
    addSubview(titleLabel)

    NSLayoutConstraint.activate([
      imageView.heightAnchor.constraint(equalToConstant: 50),
      imageView.widthAnchor.constraint(equalToConstant: 50),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
    ])
  }

  // MARK: Public

  public static func size(for viewModel: ViewModel) -> CGSize {
    let height: CGFloat = 100
    let width = (viewModel.titleText?.width(usingFont: Font.with(size: 20, design: .round, traits: .bold)) ?? 0) + 30

//    let tempWidth: Bool = width >= 100 && width < 130

    return CGSize(width: max(width, 130), height: height)
  }

  // MARK: Private

  private let imageView = UIImageView()
  private let titleLabel = UILabel()

  private func setSelected(flag: Bool, animated: Bool) {
    if animated {
      UIView.animate(withDuration: 0.15, delay: 0, options: .transitionCrossDissolve, animations: {
        self.backgroundColor = flag ? .accent : .option
        self.titleLabel.textColor = flag ? .white : .dark
        self.imageView.alpha = flag ? 0 : 1
      }, completion: nil)
    } else {
      backgroundColor = flag ? .accent : .option
      titleLabel.textColor = flag ? .white : .dark
      imageView.alpha = flag ? 0 : 1
    }
  }
}

// MARK: Decoratable

extension ImageOptionCollectionCell: Decoratable {
  public typealias ViewModel = ImageOptionCollectionCellViewModel

  public func decorate(model: ViewModel) {
    if let named = model.image {
      imageView.image = named
    } else {
      imageView.image = nil
    }
    titleLabel.text = model.titleText

    setSelected(flag: model.isSelected, animated: false)
  }
}
