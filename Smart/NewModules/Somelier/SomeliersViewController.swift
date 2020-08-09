//
//  SomeliersViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 04.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class SomeliersViewController: UIViewController {

    private enum Constants {

        static let inset: CGFloat = 30
        static let rowCount = 2
    }

    // MARK: - Private Properties

    private let collectionViewLayout: UICollectionViewFlowLayout = {
        let rowCount = Constants.rowCount
        let itemWidth = Int((UIScreen.main.bounds.width - Constants.inset * CGFloat(rowCount + 1)) / CGFloat(rowCount))
        let itemHeight = Int(Double(itemWidth)*1.4)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.inset, bottom: 0, right: Constants.inset)
        layout.minimumLineSpacing = Constants.inset
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.footerReferenceSize = .init(width: 0, height: 20)

        return layout
    }()

    private lazy var collectionView = UICollectionView(frame: view.frame, collectionViewLayout: collectionViewLayout)

    private var someliers: [String] = ["k", "k", "k", "k", "k", "k", "k", "k", "k", "k", "k", "k"] {
        didSet {
            loadViewIfNeeded()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SomelierCell.self)

        view.addSubview(collectionView)
    }

}

extension SomeliersViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        someliers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SomelierCell.reuseId, for: indexPath) as? SomelierCell {
            return cell
        }

        return UICollectionViewCell()
    }

}

extension SomeliersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = DetailSomelierViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
