//
//  VinchySimpleConiniousCaruselCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 02.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import VinchyCore
import Display
import StringFormatting
import CommonUI

protocol VinchySimpleConiniousCaruselCollectionCellDelegate: AnyObject {
    func didTapBootleCell(wineID: Int64)
    func didTapCompilationCell(wines: [Wine], title: String?)
}

struct VinchySimpleConiniousCaruselCollectionCellViewModel: ViewModelProtocol {

    fileprivate let type: CollectionType
    fileprivate let collections: [Collection]

    public init(type: CollectionType, collections: [Collection]) {
        self.type = type
        self.collections = collections
    }
}

final class VinchySimpleConiniousCaruselCollectionCell: UICollectionViewCell, Reusable {

    weak var delegate: VinchySimpleConiniousCaruselCollectionCellDelegate?

    private var type: CollectionType!

    private var collections: [Collection] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    private lazy var collectionView: UICollectionView = {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StoryCollectionCell.self, WineCollectionViewCell.self, MainSubtitleCollectionCell.self)
        collectionView.delaysContentTouches = false
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

}

extension VinchySimpleConiniousCaruselCollectionCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collections.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch self.type {
        case .mini:
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionCell.reuseId, for: indexPath) as! StoryCollectionCell
            cell.decorate(model: .init(imageURL: collections[safe: indexPath.row]?.imageURL?.toURL, titleText: collections[safe: indexPath.row]?.title))
            return cell

        case .big:
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainSubtitleCollectionCell.reuseId, for: indexPath) as! MainSubtitleCollectionCell
            cell.decorate(model: .init(subtitleText: collections[safe: indexPath.row]?.title, imageURL: collections[safe: indexPath.row]?.imageURL?.toURL))
            return cell

        case .promo:
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainSubtitleCollectionCell.reuseId, for: indexPath) as! MainSubtitleCollectionCell
            cell.decorate(model: .init(subtitleText: collections[safe: indexPath.row]?.title, imageURL: collections[safe: indexPath.row]?.imageURL?.toURL))
            return cell

        case .bottles:
            
            guard let collection = collections.first, let collectionItem = collection.wineList[safe: indexPath.row] else {
                return .init()
            }

            switch collectionItem {
            case .wine(let wine):
                // swiftlint:disable:next force_cast
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WineCollectionViewCell.reuseId, for: indexPath) as! WineCollectionViewCell
                cell.decorate(model: .init(imageURL: wine.mainImageUrl?.toURL, titleText: wine.title, subtitleText: countryNameFromLocaleCode(countryCode: wine.winery?.countryCode), backgroundColor: .randomColor))
                return cell
            case .ads:
                return .init()
            }

        case .none, .shareUs, .infinity, .smartFilter:
            return .init()
        }
    }
}

extension VinchySimpleConiniousCaruselCollectionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch type {
        case .mini, .big, .promo:
            delegate?.didTapCompilationCell(wines: collections[indexPath.row].wineList.compactMap({ (collectionItem) -> Wine? in
                switch collectionItem {
                case .wine(let wine):
                    return wine
                case .ads:
                    return nil
                }
            }), title: collections[indexPath.row].title)

        case .bottles:
            guard let collection = collections.first, let collectionItem = collection.wineList[safe: indexPath.row] else {
                return
            }
            switch collectionItem {
            case .wine(let wine):
                delegate?.didTapBootleCell(wineID: wine.id)
            case .ads:
                break
            }

        case .none, .shareUs, .infinity, .smartFilter:
            break
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width: CGFloat

        switch self.type.itemSize.width {
        case .absolute(let _width):
            width = _width
        case .dimension(let _width):
            width = collectionView.frame.width * _width
        }

        return .init(width: width, height: collectionView.frame.height)
    }
}

extension VinchySimpleConiniousCaruselCollectionCell: Decoratable {

    typealias ViewModel = VinchySimpleConiniousCaruselCollectionCellViewModel

    func decorate(model: ViewModel) {
        self.type = model.type
        self.collections = model.collections
    }
}
