//
//  LoveViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 10.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import RealmSwift
import Core
import CommonUI
import StringFormatting
import Database

private enum LoveViewControllerState {
    case like, dislike
}

final class LoveViewController: UIViewController {

    private enum Constants {
        static let inset: CGFloat = 10
        static let rowCount = 2
    }

    private let dataBase = Database<Wine>()

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)

    private static let collectionViewLayout: UICollectionViewLayout = {
        let rowCount = Constants.rowCount
        let itemWidth = Int((UIScreen.main.bounds.width - Constants.inset * CGFloat(rowCount + 1)) / CGFloat(rowCount))
        let itemHeight = Int(Double(itemWidth)*1.4)

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.inset, bottom: 0, right: Constants.inset)
        layout.minimumLineSpacing = Constants.inset
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)

        return layout
    }()

    private var currentState: LoveViewControllerState = .like {
        didSet {
            if currentState == .like {
                navigationItem.title = localized("you_liked").firstLetterUppercased()
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.slash"), style: .plain, target: self, action: #selector(switchToUnfavourite))
                wines = dataBase.all(type: Wine.self, at: .like)
            } else if currentState == .dislike {
                navigationItem.title = localized("you_disliked").firstLetterUppercased()
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(switchToUnfavourite))
                wines = dataBase.all(type: Wine.self, at: .dislike)
            }
        }
    }

    private lazy var likeRealm = realm(path: .like)
    private var likeNotificationToken: NotificationToken?

    private lazy var dislikeRealm = realm(path: .dislike)
    private var dislikeNotificationToken: NotificationToken?

    private var wines: [Wine] = [] {
        didSet {

            if wines.isEmpty {
                showEmptyView()
            } else {
                hideEmptyView()
            }

            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    // MARK: - Initializers

    init() {
        super.init(nibName: nil, bundle: nil)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WineCollectionViewCell.self, forCellWithReuseIdentifier: WineCollectionViewCell.description())

        likeNotificationToken = likeRealm.observe { notification, realm in
            if self.currentState == .like {
                self.wines = self.dataBase.all(type: Wine.self, at: .like)
            }
        }

        dislikeNotificationToken = dislikeRealm.observe { notification, realm in
            if self.currentState == .dislike {
                self.wines = self.dataBase.all(type: Wine.self, at: .dislike)
            }
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        currentState = .like
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .mainBackground
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        collectionView.frame = view.bounds
    }

    deinit {
        likeNotificationToken?.invalidate()
        dislikeNotificationToken?.invalidate()
    }

    // MARK: - Private Methods

    private func hideEmptyView() {
        collectionView.backgroundView = nil
    }

    private func showEmptyView() {
        let errorView = ErrorView(frame: view.frame)
        errorView.delegate = self
        errorView.configure(title: "Пока пусто", description: "Нет сохраненных адресов", buttonText: "Добавить")
        // TODO: - Localize
        collectionView.backgroundView = errorView
    }

    @objc private func switchToUnfavourite() {
        currentState = currentState == .like ? .dislike : .like
    }

}

extension LoveViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        wines.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let wine = wines[safe: indexPath.row] else { return .init() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WineCollectionViewCell.description(), for: indexPath) as! WineCollectionViewCell
        cell.background.backgroundColor = .option
        cell.decorate(model: .init(imageURL: wine.mainImageUrl, title: wine.title, subtitle: String(wine.year)))
        return cell
    }
}

extension LoveViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let wine = wines[safe: indexPath.row] else { return }
        navigationController?.pushViewController(Assembly.buildDetailModule(wine: wine), animated: true)
    }
}

extension LoveViewController: ErrorViewDelegate {
    func didTapErrorButton(_ button: UIButton) {
        tabBarController?.selectedIndex = 0
    }
}
