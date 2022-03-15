//
//  OptionsViewController.swift
//  Questions
//
//  Created by Алексей Смирнов on 12.03.2022.
//

import DisplayMini
import EpoxyBars
import EpoxyCollectionView
import UIKit

// MARK: - OptionsViewController

final class OptionsViewController: UIViewController {

  // MARK: Internal

  var interactor: OptionsInteractorProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never

    view.backgroundColor = .mainBackground

    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])

    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark", withConfiguration: imageConfig), style: .plain, target: self, action: #selector(closeSelf))

    bottomBarInstaller.install()

    interactor?.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let dataSource = (navigationController as? QuestionsNavigationController)?.dataSource ?? [:]
    interactor?.viewWillAppear(dataSource: dataSource)
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    if UIApplication.shared.applicationState != .background {
      coordinator.animate(alongsideTransition: { _ in
        self.collectionViewSize = size
        self.collectionView.setSections(self.sections, animated: false)
      })
    }
  }

  // MARK: Private

  private lazy var bottomBarInstaller = BottomBarInstaller(
    viewController: self,
    bars: bars)

  private var supplementaryView: UIView?

  private lazy var collectionView: CollectionView = {
    let collectionView = CollectionView(
      layout: layout,
      configuration: .init(
        usesBatchUpdatesForAllReloads: false,
        usesCellPrefetching: true,
        usesAccurateScrollToItem: true))
    collectionView.backgroundColor = .clear
    collectionView.delaysContentTouches = false
    collectionView.contentInset = .init(top: 0, left: 0, bottom: 10, right: 0)
//    collectionView.scrollDelegate = self
    return collectionView
  }()

  private lazy var collectionViewSize: CGSize = view.frame.size

  private let layout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionHeadersPinToVisibleBounds = true
    layout.sectionInset = .init(top: 0, left: 24, bottom: 0, right: 24)
    layout.minimumInteritemSpacing = 24
    return layout
  }()

  private var bottomBarPriceView: BottomPriceBarView?

  private var viewModel: OptionsViewModel = .empty

  @BarModelBuilder
  private var bars: [BarModeling] {
    if let bottomPriceBarViewModel = viewModel.bottomBarViewModel {
      [
        BottomPriceBarView.barModel(
          dataID: nil,
          content: bottomPriceBarViewModel,
          behaviors: .init(didSelect: { [weak self] _ in
            self?.interactor?.didTapNextButton()
          }),
          style: .init(kind: .buttonOnly))
          .willDisplay({ [weak self] context in
            guard let self = self else { return }
            self.bottomBarPriceView = context.view
            if self.viewModel.isNextButtonEnabled {
              self.bottomBarPriceView?.button.enable()
            } else {
              self.bottomBarPriceView?.button.disable()
            }
          }),
      ]
    } else {
      []
    }
  }

  @SectionModelBuilder
  private var sections: [SectionModel] {
    SectionModel(dataID: UUID()) {
      viewModel.items.compactMap { item in
        switch item {
        case .common(let content):
          let width: CGFloat = collectionViewSize.width - 48
          let height: CGFloat = content.height(for: width)
          return OptionView.itemModel(
            dataID: UUID(),
            content: content,
            style: .init())
            .flowLayoutItemSize(.init(width: width, height: height))
            .didSelect { [weak self] _ in
              self?.interactor?.didSelectOption(id: content.id)
            }
        }
      }
    }
    .flowLayoutSectionInset(UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0))
    .supplementaryItems(ofKind: UICollectionView.elementKindSectionHeader, [
      OptionHeader.supplementaryItemModel(
        dataID: UUID(),
        content: viewModel.header,
        style: .init())
        .setBehaviors { [weak self] context in
          self?.supplementaryView = context.view
        },
    ])
    .flowLayoutHeaderReferenceSize(.init(width: collectionViewSize.width, height: viewModel.header.height(for: collectionViewSize.width)))
  }

  @objc
  private func closeSelf() {
    interactor?.didTapClose()
  }
}

// MARK: OptionsViewControllerProtocol

extension OptionsViewController: OptionsViewControllerProtocol {
  func updateUI(viewModel: OptionsViewModel) {
    self.viewModel = viewModel
    collectionView.setSections(sections, animated: true)
    navigationItem.title = viewModel.navigationTitle
    bottomBarInstaller.setBars(bars, animated: true)
    if viewModel.isNextButtonEnabled {
      bottomBarPriceView?.button.enable()
    } else {
      bottomBarPriceView?.button.disable()
    }
  }
}
