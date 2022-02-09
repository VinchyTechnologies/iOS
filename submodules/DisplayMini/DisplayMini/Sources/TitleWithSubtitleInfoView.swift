//
//  TitleWithSubtitleInfoView.swift
//  Smart
//
//  Created by Aleksei Smirnov on 25.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import EpoxyCore
import UIKit

// MARK: - TitleWithSubtitleInfoCollectionViewCellViewModel

public struct TitleWithSubtitleInfoCollectionViewCellViewModel: ViewModelProtocol, Equatable {
  fileprivate let titleText: String?
  fileprivate let subtitleText: String?

  public init(titleText: String?, subtitleText: String?) {
    self.titleText = titleText
    self.subtitleText = subtitleText
  }
}

// MARK: - TitleWithSubtitleInfoView

public final class TitleWithSubtitleInfoView: UIView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = style.backgroundColor

    titleLabel.numberOfLines = 0
    subtitleLabel.numberOfLines = 0

    let stackView = UIStackView(arrangedSubviews: [subtitleLabel, titleLabel])
    stackView.axis = .vertical
    stackView.spacing = 2

    addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor, constant: 7),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public struct Style: Hashable {
    public let backgroundColor: UIColor
    public init(backgroundColor: UIColor) {
      self.backgroundColor = backgroundColor
    }
  }

  public typealias Content = TitleWithSubtitleInfoCollectionViewCellViewModel

  public static func height(width: CGFloat, content: Content) -> CGFloat {
    let titleHeight = (content.titleText ?? "").height(forWidth: width - 48, font: Font.medium(20))
    let subtitleHeight = (content.subtitleText ?? "").height(forWidth: width - 48, font: Font.regular(14))

    return titleHeight + subtitleHeight + 7 + 7 + 2
  }

  public func setContent(_ content: Content, animated: Bool) {
    titleLabel.attributedText = NSAttributedString(string: content.titleText ?? "", font: Font.medium(20), textColor: .dark)
    subtitleLabel.attributedText = NSAttributedString(string: content.subtitleText ?? "", font: Font.regular(14), textColor: .blueGray)
  }

  // MARK: Private

  private let style: Style
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
}
