//
//  SavedViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 03.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Epoxy
import UIKit

// MARK: - SavedViewController

final class SavedViewController: CollectionViewController {

  // MARK: Lifecycle

  init() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    super.init(layout: layout)
    layout.itemSize = .init(width: view.frame.width, height: view.frame.height)

  }

  // MARK: Internal

  var interactor: SavedInteractorProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()

//    edgesForExtendedLayout = []
    navigationItem.largeTitleDisplayMode = .never

    interactor?.viewDidLoad()

    topBarInstaller.install()
    updateUI(viewModel: .init(sections: [.liked, .liked], navigationTitleText: "Saved"))
  }

  override func makeCollectionView() -> CollectionView {

    let collectionView = CollectionView(layout: layout)
    collectionView.isPagingEnabled = true
    collectionView.backgroundColor = .yellow
    return collectionView
  }

  // MARK: Private

  private lazy var topBarInstaller = TopBarInstaller(
    viewController: self,
    bars: bars)

  private var viewModel: SavedViewModel = .empty

  @SectionModelBuilder
  private var sections: [SectionModel] {
    viewModel.sections.map({ section in
      switch section {
      case .liked:
        return SectionModel(dataID: UUID()) {
          ControllerCell.itemModel(
            dataID: UUID(),
            content: .init(id: UUID().uuidString),
            style: .init(id: UUID().uuidString))
            .setBehaviors({ [unowned self] context in
//              addChild(context.view.vc)
//              context.view.vc.didMove(toParent: self)
            })
        }
      }
    })
  }

  @BarModelBuilder
  private var bars: [BarModeling] {
    [TextRow.barModel(dataID: nil, content: .init(id: 1), behaviors: nil, style: .small)]
  }

}

// MARK: SavedViewControllerProtocol

extension SavedViewController: SavedViewControllerProtocol {
  func updateUI(viewModel: SavedViewModel) {
    self.viewModel = viewModel
    navigationItem.title = viewModel.navigationTitleText
    setSections(sections, animated: true)
  }
}
