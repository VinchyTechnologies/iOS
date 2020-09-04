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
import MagazineLayout


protocol VinchySimpleConiniousCaruselCollectionCellDelegate: AnyObject {
    func didTapBootleCell(wineID: Int64)
    func didTapCompilationCell(wines: [Wine], title: String?)
}

struct VinchySimpleConiniousCaruselCollectionCellViewModel: ViewModelProtocol {
    let collections: [Collection]
}

final class VinchySimpleConiniousCaruselCollectionCell: MagazineLayoutCollectionViewCell, Reusable {

    weak var delegate: VinchySimpleConiniousCaruselCollectionCellDelegate?

    private var collections: [Collection] = [] {
        didSet {
            collectionView.collectionViewLayout = layout
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    private lazy var layout = UICollectionViewCompositionalLayout(sectionProvider: { (section, env) -> NSCollectionLayoutSection? in
        var section: NSCollectionLayoutSection

        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

        let type = self.collections.first!.type
        let width: NSCollectionLayoutDimension

        switch type.itemSize.width {
        case .absolute(let _width):
            width = .absolute(_width)
        case .dimension(let _width):
            width = .fractionalWidth(_width)
        }

        switch type {
        case .mini:
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: width, heightDimension: .fractionalHeight(1)), subitems: [item])
            section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous

        case .big:
            item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: width, heightDimension: .fractionalHeight(1)), subitems: [item])
            section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous

        case .promo:
            item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: width, heightDimension: .fractionalHeight(1)), subitems: [item])
            section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .paging

        case .bottles:
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: width, heightDimension: .fractionalHeight(1)), subitems: [item])
            section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.orthogonalScrollingBehavior = .continuous
        }

        section.contentInsets = .init(top: 0, leading: 10, bottom: 5, trailing: 0)
        return section
    }, configuration: UICollectionViewCompositionalLayoutConfiguration())

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StoryCollectionCell.self, WineCollectionViewCell.self, MainSubtitleCollectionCell.self)
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(collectionView)
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

        switch collections.first!.type {
        case .mini:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionCell.reuseId, for: indexPath) as! StoryCollectionCell
            cell.decorate(model: .init(imageURL: collections[safe: indexPath.row]?.imageURL, title: collections[safe: indexPath.row]?.title))
            return cell

        case .big:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainSubtitleCollectionCell.reuseId, for: indexPath) as! MainSubtitleCollectionCell
            cell.decorate(model: .init(subtitle: collections[safe: indexPath.row]?.title, imageURL: collections[safe: indexPath.row]?.imageURL))
            return cell

        case .promo:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainSubtitleCollectionCell.reuseId, for: indexPath) as! MainSubtitleCollectionCell
            cell.decorate(model: .init(subtitle: collections[safe: indexPath.row]?.title, imageURL: collections[safe: indexPath.row]?.imageURL))
            return cell

        case .bottles:
            guard let collection = collections.first, let wine = collection.wineList[safe: indexPath.row] else {
                return .init()
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WineCollectionViewCell.reuseId, for: indexPath) as! WineCollectionViewCell
            cell.decorate(model: .init(imageURL: wine.mainImageUrl ?? "", title: wine.title, subtitle: nil))
            cell.background.backgroundColor = .option
            return cell
        }
    }
}

extension VinchySimpleConiniousCaruselCollectionCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collections.first?.type {
        case .mini, .big, .promo:
            delegate?.didTapCompilationCell(wines: collections[indexPath.row].wineList, title: collections[indexPath.row].title)
        case .bottles:
            guard let collection = collections.first, let wine = collection.wineList[safe: indexPath.row] else {
                return
            }
            delegate?.didTapBootleCell(wineID: wine.id)
        case .none:
            break
        }
    }
}

extension VinchySimpleConiniousCaruselCollectionCell: Decoratable {

    typealias ViewModel = VinchySimpleConiniousCaruselCollectionCellViewModel

    func decorate(model: ViewModel) {
        self.collections = model.collections
    }
}
