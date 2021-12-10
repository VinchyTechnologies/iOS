//
//  BigCollectionView.swift
//  Smart
//
//  Created by Алексей Смирнов on 26.10.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import EpoxyCollectionView
import EpoxyCore
import Foundation
import VinchyCore

// MARK: - BigCollectionView

//protocol StoriesCollectionViewDelegate: AnyObject {
//  func didTapStory(id: Int)
//}

final class BigCollectionView: CollectionView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    self.style = style
    super.init(layout: UICollectionViewCompositionalLayout.epoxy)
    delaysContentTouches = false
    prefetchDelegate = self
  }

  // MARK: Internal

  struct Style: Hashable {
    enum Kind {
      case big, promo
    }

    let id: String
    let kind: Kind

    init(id: String = UUID().uuidString, kind: Kind) {
      self.id = id
      self.kind = kind
    }
  }

  typealias Content = [MainSubtitleView.Content]

  weak var storiesCollectionViewDelegate: StoriesCollectionViewDelegate?

  static func height(for style: Style) -> CGFloat {
    switch style.kind {
    case .big:
      return 155

    case .promo:
      return 120
    }
  }

  func setContent(_ content: Content, animated: Bool) {
    let sectionModel = SectionModel(dataID: UUID()) {
      content.enumerated().map { index, storyViewViewModel in
        switch style.kind {
        case .big:
          return MainSubtitleView.itemModel(
            dataID: index,
            content: storyViewViewModel,
            style: .init(kind: .big))
            .didSelect { [weak self] _ in
              self?.storiesCollectionViewDelegate?.didTapStory(title: storyViewViewModel.subtitleText, shortWines: storyViewViewModel.wines)
            }

        case .promo:
          return MainSubtitleView.itemModel(
            dataID: index,
            content: storyViewViewModel,
            style: .init(kind: .promo))
            .didSelect { [weak self] _ in
              self?.storiesCollectionViewDelegate?.didTapStory(title: storyViewViewModel.subtitleText, shortWines: storyViewViewModel.wines)
            }
        }
      }
    }
    .compositionalLayoutSection(layoutSection)

    setSections([sectionModel], animated: true)
  }

  // MARK: Private

  private let style: Style

  private var layoutSection: NSCollectionLayoutSection? {
    switch style.kind {
    case .big:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(250), heightDimension: .absolute(155)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(250), heightDimension: .absolute(155)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.interGroupSpacing = 8
      section.orthogonalScrollingBehavior = .continuous
      section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
      return section

    case .promo:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(290), heightDimension: .absolute(120)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(290), heightDimension: .absolute(120)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.interGroupSpacing = 8
      section.orthogonalScrollingBehavior = .continuous
      section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
      return section
    }
  }
}

// MARK: CollectionViewPrefetchingDelegate

extension BigCollectionView: CollectionViewPrefetchingDelegate {
  func collectionView(_ collectionView: CollectionView, prefetch items: [AnyItemModel]) {
    for item in items {
      if let content = (item.model as? ItemModel<MainSubtitleView>)?.erasedContent as? MainSubtitleViewViewModel {
        ImageLoader.shared.prefetch(url: content.imageURL)
      }
    }
  }

  func collectionView(_ collectionView: CollectionView, cancelPrefetchingOf items: [AnyItemModel]) {
    for item in items {
      if
        let content = (item.model as? ItemModel<MainSubtitleView>)?.erasedContent as? MainSubtitleViewViewModel,
        let url = content.imageURL
      {
        ImageLoader.shared.cancelPrefetch([url])
      }
    }
  }
}

// MARK: - MainSubtitleViewViewModel

struct MainSubtitleViewViewModel: Equatable {
  let subtitleText: String?
  fileprivate let imageURL: URL?
  let wines: [ShortWine]

  public init(subtitleText: String?, imageURL: URL?, wines: [ShortWine]) {
    self.subtitleText = subtitleText
    self.imageURL = imageURL
    self.wines = wines
  }
}

// MARK: - MainSubtitleView

final class MainSubtitleView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = .option
    imageView.contentMode = .scaleToFill
    imageView.layer.cornerRadius = 15
    imageView.clipsToBounds = true

    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    subtitleLabel.font = Font.semibold(15)
    subtitleLabel.textColor = .blueGray

    addSubview(imageView)
    addSubview(subtitleLabel)
    NSLayoutConstraint.activate([
      subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
      subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
      subtitleLabel.heightAnchor.constraint(equalToConstant: 16),
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -3),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {

    enum Kind {
      case big, promo
    }

    let kind: Kind
  }

  typealias Content = MainSubtitleViewViewModel

  func setContent(_ content: Content, animated: Bool) {
    subtitleLabel.text = content.subtitleText
    imageView.loadImage(url: content.imageURL)
  }

  // MARK: Private

  private let style: Style
  private let subtitleLabel = UILabel()
  private let imageView = UIImageView()
}

// MARK: HighlightableView

extension MainSubtitleView: HighlightableView {
  func didHighlight(_ isHighlighted: Bool) {
    UIView.animate(
      withDuration: 0.15,
      delay: 0,
      options: [.beginFromCurrentState, .allowUserInteraction])
    {
      self.transform = isHighlighted
        ? CGAffineTransform(scaleX: 0.95, y: 0.95)
        : .identity
    }
  }
}
