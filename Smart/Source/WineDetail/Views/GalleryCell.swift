//
//  GalleryCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 24.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import FSPagerView
import UIKit

// MARK: - GalleryCellViewModel

struct GalleryCellViewModel: ViewModelProtocol {
  fileprivate let urls: [String?]

  public init(urls: [String?]) {
    self.urls = urls
  }
}

// MARK: - GalleryCell

final class GalleryCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(pager)
    pager.fill()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Private

  private lazy var pager: FSPagerView = {
    $0.dataSource = self
    $0.delegate = self
    $0.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
    return $0
  }(FSPagerView())

  private var urls: [URL] = [] {
    didSet {
      DispatchQueue.main.async {
        self.pager.reloadData()
      }
    }
  }
}

// MARK: FSPagerViewDataSource, FSPagerViewDelegate

extension GalleryCell: FSPagerViewDataSource, FSPagerViewDelegate {
  func numberOfItems(in _: FSPagerView) -> Int {
    urls.count
  }

  func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
    let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)

    cell.imageView?.loadBottle(url: urls[safe: index])

    cell.imageView?.contentMode = .scaleAspectFit
    cell.contentView.layer.shadowColor = UIColor.white.cgColor
    return cell
  }

  func pagerView(_: FSPagerView, shouldSelectItemAt _: Int) -> Bool {
    false
  }

  func pagerView(_: FSPagerView, shouldHighlightItemAt _: Int) -> Bool {
    false
  }
}

// MARK: Decoratable

extension GalleryCell: Decoratable {
  typealias ViewModel = GalleryCellViewModel

  func decorate(model: ViewModel) {
    urls = model.urls.compactMap { $0?.toURL }
  }
}
