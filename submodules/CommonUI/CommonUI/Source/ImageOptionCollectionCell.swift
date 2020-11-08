//
//  ImageOptionCollectionCell.swift
//  CommonUI
//
//  Created by Aleksei Smirnov on 27.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

public struct ImageOptionCollectionCellViewModel: ViewModelProtocol {

  fileprivate let imageName: String?
  fileprivate let titleText: String?
  fileprivate let isSelected: Bool

  public init(imageName: String?, titleText: String?, isSelected: Bool) {
    self.imageName = imageName
    self.titleText = titleText
    self.isSelected = isSelected
  }
}

public final class ImageOptionCollectionCell: HighlightCollectionCell, Reusable {

  private let imageView = UIImageView()
  private let titleLabel = UILabel()

  public override init(frame: CGRect) {
    super.init(frame: frame)

    highlightStyle = .scale

    backgroundColor = .option
    layer.cornerRadius = 15
    clipsToBounds = true

    [imageView, titleLabel].forEach({ $0.translatesAutoresizingMaskIntoConstraints = false })

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

  required init?(coder: NSCoder) { fatalError() }

  private func setSelected(flag: Bool, animated: Bool) {
    if animated {
      UIView.animate(withDuration: 0.15, delay: 0, options: .transitionCrossDissolve, animations: {
        self.backgroundColor = flag ? .accent : .option
        self.titleLabel.textColor = flag ? .white : .dark
        self.imageView.alpha = flag ? 0 : 1
      }, completion: nil)
    } else {
      self.backgroundColor = flag ? .accent : .option
      self.titleLabel.textColor = flag ? .white : .dark
      self.imageView.alpha = flag ? 0 : 1
    }
  }

  public static func size(for viewModel: ViewModel) -> CGSize {
    let height: CGFloat = 100
    let width = (viewModel.titleText?.width(usingFont: Font.with(size: 20, design: .round, traits: .bold)) ?? 0) + 30

//    let tempWidth: Bool = width >= 100 && width < 130

    return CGSize(width: max(width, 130), height: height)
  }
}

extension ImageOptionCollectionCell: Decoratable {

  public typealias ViewModel = ImageOptionCollectionCellViewModel

  public func decorate(model: ViewModel) {
    if let named = model.imageName {
      imageView.image = UIImage(named: named)
    } else {
      imageView.image = nil
    }
    titleLabel.text = model.titleText

    setSelected(flag: model.isSelected, animated: false)
  }
}
