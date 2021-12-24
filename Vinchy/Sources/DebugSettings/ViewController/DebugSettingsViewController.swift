//
//  DebugSettingsViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 14.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import EpoxyCollectionView
import UIKit

// MARK: - DebugSettingsViewController

final class DebugSettingsViewController: CollectionViewController {

  // MARK: Lifecycle

  init() {
    let layout = UICollectionViewCompositionalLayout.list
    super.init(layout: layout)
  }

  // MARK: Internal

  var interactor: DebugSettingsInteractorProtocol?

  var items: [ItemModeling] {
    viewModel.sections.map({ section in
      switch section {
      case .navigateVinchyStore(let content):
        return TextRow.itemModel(
          dataID: UUID(),
          content: content,
          style: .large)
          .didSelect { [weak self] _ in
            self?.interactor?.didSelectOpenTestVinchyStore()
          }
      }
    })
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    collectionView.backgroundColor = .mainBackground
    interactor?.viewDidLoad()
  }

  // MARK: Private

  private var viewModel: DebugSettingsViewModel = .empty

}

// MARK: DebugSettingsViewControllerProtocol

extension DebugSettingsViewController: DebugSettingsViewControllerProtocol {

  func updateUI(viewModel: DebugSettingsViewModel) {
    self.viewModel = viewModel
    navigationItem.title = viewModel.navigationTitleText
    setItems(items, animated: true)
  }
}
