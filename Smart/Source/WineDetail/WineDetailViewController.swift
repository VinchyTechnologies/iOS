//
//  WineDetailViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 24.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display
import VinchyCore

fileprivate enum Section {
    case gallery(urls: [String?])
}

final class WineDetailViewController: UIViewController, Alertable {

    private var wine: Wine? {
        didSet {
            loadViewIfNeeded()
            guard let wine = wine else { return }
            var sections: [Section] = []

            let arg1 = [String(wine.mainImageUrl)]
            let arg2 = [String(wine.labelImageUrl)]
            let imageURLs = (arg1 + arg2 + Array(wine.imageURLs)).map { (str) -> String? in
                str == "" ? nil : str
            }

            sections.append(.gallery(urls: imageURLs))

            self.sections = sections
        }
    }

    private var sections: [Section] = [] {
        didSet {
            collectionView.collectionViewLayout = layout
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    private lazy var layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
        switch self.sections[sectionNumber] {
        case .gallery:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(300)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.backgroundColor = .mainBackground
        collectionView.dataSource = self

        collectionView.register(GalleryCell.self)
        return collectionView
    }()

    init(wineID: Int64) {
        super.init(nibName: nil, bundle: nil)

        loadWineInfo(wineID: wineID)
        
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        collectionView.frame = view.frame
    }

    private func loadWineInfo(wineID: Int64) {
        Wines.shared.getDetailWine(wineID: wineID) { [weak self] result in
            switch result {
            case .success(let wine):
                self?.wine = wine
            case .failure(let error):
                self?.showAlert(message: error.localizedDescription)
            }
        }
    }
}

extension WineDetailViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .gallery(let urls):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.reuseId, for: indexPath) as! GalleryCell
            cell.decorate(model: .init(urls: urls))
            return cell
        }
    }
}
