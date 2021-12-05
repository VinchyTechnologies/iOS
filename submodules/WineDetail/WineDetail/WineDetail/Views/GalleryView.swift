//
//  GalleryView.swift
//  Smart
//
//  Created by Aleksei Smirnov on 24.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import EpoxyCore
import FSPagerView
import UIKit

// MARK: - GalleryCellViewModel

struct GalleryCellViewModel: ViewModelProtocol, Equatable {
  fileprivate let urls: [String?]

  public init(urls: [String?]) {
    self.urls = urls
  }
}

// MARK: - GalleryView

final class GalleryView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    addSubview(pager)
    pager.fill()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {
  }

  typealias Content = GalleryCellViewModel

  static var height: CGFloat {
    300
  }

  func setContent(_ content: Content, animated: Bool) {
    urls = content.urls.compactMap { $0?.toURL }
  }

  // MARK: Private

  private let style: Style

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

extension GalleryView: FSPagerViewDataSource, FSPagerViewDelegate {
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
