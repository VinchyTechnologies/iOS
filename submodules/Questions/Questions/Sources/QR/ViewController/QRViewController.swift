//
//  QRViewController.swift
//  Questions
//
//  Created by Алексей Смирнов on 13.03.2022.
//

import DisplayMini
import EpoxyCollectionView
import UIKit

// MARK: - QRViewController

final class QRViewController: CollectionViewController {

  // MARK: Lifecycle

  init() {
    super.init(layout: UICollectionViewFlowLayout())
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  private(set) var loadingIndicator = ActivityIndicatorView()

  var interactor: QRInteractorProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never

    if isModal {
      let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
      navigationItem.leftBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "chevron.down", withConfiguration: imageConfig),
        style: .plain,
        target: self,
        action: #selector(didTapCloseBarButtonItem(_:)))
    }

    collectionView.backgroundColor = .mainBackground
    collectionView.delaysContentTouches = false
    collectionView.contentInset = .init(top: 0, left: 0, bottom: 10, right: 0)

    interactor?.viewDidLoad()
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
      self.collectionViewSize = size
      self.setSections(self.sections, animated: false)
    })
  }

  // MARK: Private

  private lazy var collectionViewSize: CGSize = view.frame.size
  private var viewModel: QRViewModel = .empty

  @SectionModelBuilder
  private var sections: [SectionModel] {
    viewModel.sections.compactMap { section in
      switch section {
      case .logo(let content):
        let width = collectionViewSize.width - 48
        return SectionModel(dataID: UUID()) {
          LogoRow.itemModel(
            dataID: UUID(),
            content: content,
            style: .large)
        }
        .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 8, right: 24))
        .flowLayoutItemSize(.init(width: width, height: content.height(for: width)))

      case .address(let content):
        let width: CGFloat = collectionViewSize.width - 48
        let height: CGFloat = content.height(for: width)
        return SectionModel(dataID: UUID()) {
          StoreMapRow.itemModel(
            dataID: UUID(),
            content: content,
            style: .init())
        }
        .flowLayoutItemSize(.init(width: width, height: height))
        .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 16, right: 24))

      case .title(let content):
        let style: Label.Style = .init(font: Font.heavy(30), showLabelBackground: false, textAligment: .center)
        let width: CGFloat = collectionViewSize.width - 48
        let height: CGFloat = Label.height(
          for: content,
          width: width,
          style: style)
        return SectionModel(dataID: UUID()) {
          Label.itemModel(
            dataID: UUID(),
            content: content,
            style: style)
        }
        .flowLayoutSectionInset(.init(top: 12, left: 24, bottom: 8, right: 24))
        .flowLayoutItemSize(.init(width: width, height: height))

      case .subtitle(let content):
        let width: CGFloat = collectionViewSize.width - 48 * 2
        let height: CGFloat = Label.height(
          for: content,
          width: width,
          style: .style(with: .regular, textAligment: .center))
        return SectionModel(dataID: UUID()) {
          Label.itemModel(
            dataID: UUID(),
            content: content,
            style: .style(with: .regular, textAligment: .center, textColor: .blueGray))
        }
        .flowLayoutItemSize(.init(width: width, height: height))

      case .qr(let content):
        let width: CGFloat = 200
        let height: CGFloat = 200
        return SectionModel(dataID: UUID()) {
          QRView.itemModel(
            dataID: UUID(),
            content: content,
            style: .init())
        }
        .flowLayoutSectionInset(.init(top: 12, left: 24, bottom: 8, right: 24))
        .flowLayoutItemSize(.init(width: width, height: height))
      }
    }
  }

  private func hideErrorView() {
    collectionView.backgroundView = nil
  }

  @objc
  private func didTapCloseBarButtonItem(_: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: QRViewControllerProtocol

extension QRViewController: QRViewControllerProtocol {
  func updateUI(viewModel: QRViewModel) {
    hideErrorView()
    self.viewModel = viewModel
    setSections(sections, animated: true)
  }

  func updateUI(errorViewModel: ErrorViewModel) {
    navigationItem.rightBarButtonItem = nil
    collectionView.setSections([], animated: false)
    let errorView = EpoxyErrorView(style: .init())
    errorView.setContent(.init(titleText: errorViewModel.titleText, subtitleText: errorViewModel.subtitleText, buttonText: errorViewModel.buttonText), animated: true)
    errorView.delegate = self
    collectionView.backgroundView = errorView
  }
}

// MARK: EpoxyErrorViewDelegate

extension QRViewController: EpoxyErrorViewDelegate {
  func didTapErrorButton(_ button: UIButton) {
    interactor?.didTapReload()
  }
}

// MARK: Loadable

extension QRViewController: Loadable {
  func startLoadingAnimation() {
    hideErrorView()
    loadingIndicator.isAnimating = true
  }
}
