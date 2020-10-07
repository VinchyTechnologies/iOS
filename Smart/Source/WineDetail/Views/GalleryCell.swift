//
//  GalleryCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 24.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display
import FSPagerView

struct GalleryCellViewModel: ViewModelProtocol {

    fileprivate let urls: [String?]

    public init(urls: [String?]) {
        self.urls = urls
    }
}

final class GalleryCell: UICollectionViewCell, Reusable {

    private var urls: [URL] = [] {
        didSet {
            DispatchQueue.main.async {
                self.pager.reloadData()
            }
        }
    }

    private lazy var pager: FSPagerView = {
        let pager = FSPagerView()
        pager.dataSource = self
        pager.delegate = self
        pager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        return pager
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(pager)
        pager.frame = frame
    }

    required init?(coder: NSCoder) { fatalError() }

}

extension GalleryCell: FSPagerViewDataSource, FSPagerViewDelegate {

    func numberOfItems(in pagerView: FSPagerView) -> Int {
        urls.count
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.sd_setImage(with: urls[index], placeholderImage: nil, options: .progressiveLoad, completed: nil)
        cell.imageView?.contentMode = .scaleAspectFit
        cell.contentView.layer.shadowColor = UIColor.white.cgColor
        return cell
    }

    func pagerView(_ pagerView: FSPagerView, shouldSelectItemAt index: Int) -> Bool {
        false
    }

    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        false
    }

}

extension GalleryCell: Decoratable {

    typealias ViewModel = GalleryCellViewModel

    func decorate(model: ViewModel) {
        self.urls = model.urls.compactMap({ $0?.toURL })
    }
}
