//
//  WineDetailViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 24.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display
import Epoxy
import GoogleMobileAds
import StringFormatting
import UIKit
import VinchyAuthorization
import VinchyCore

// MARK: - C

private enum C {
  static let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .default)
}

// MARK: - WineDetailViewController

final class WineDetailViewController: CollectionViewController {

  // MARK: Lifecycle

  init() {
    super.init(layout: UICollectionViewFlowLayout())
  }

  // MARK: Internal

  var interactor: WineDetailInteractorProtocol?

  private(set) var loadingIndicator = ActivityIndicatorView()

  var presentationCenter: OverlayPresentationCenterProtocol? = OverlayPresentationCenter(application: UIApplication.shared)

  override func viewDidLoad() {
    super.viewDidLoad()

    if isModal {
      navigationController?.becomeLazy(for: .dismiss)
      allowedOrientations = [.leftToRight, .topToBottom]
    }

    navigationItem.largeTitleDisplayMode = .never

    noteButton.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: C.imageConfig), for: .normal)
    noteButton.backgroundColor = .option
    noteButton.contentEdgeInsets = .init(top: 6, left: 6, bottom: 6, right: 6)
    noteButton.titleEdgeInsets = .init(top: 0, left: 2, bottom: 0, right: 2)
    noteButton.tintColor = .dark
    noteButton.addTarget(self, action: #selector(didTapNotes(_:)), for: .touchUpInside)

    let spacer = UIView(frame: .init(x: 0, y: 0, width: 2, height: 2))

    moreButton.setImage(UIImage(systemName: "ellipsis", withConfiguration: C.imageConfig), for: .normal)
    moreButton.backgroundColor = .option
    moreButton.contentEdgeInsets = .init(top: 6, left: 6, bottom: 6, right: 6)
    moreButton.tintColor = .dark
    moreButton.addTarget(self, action: #selector(didTapMore(_:)), for: .touchUpInside)

    let moreBarButtonItem = UIBarButtonItem(customView: moreButton)
    let noteBarButtonItem = UIBarButtonItem(customView: noteButton)
    let spacerBarItem = UIBarButtonItem(customView: spacer)
    navigationItem.rightBarButtonItems = [moreBarButtonItem, spacerBarItem, noteBarButtonItem]

    if isModal {
      let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
      navigationItem.leftBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "chevron.down", withConfiguration: imageConfig),
        style: .plain,
        target: self,
        action: #selector(didTapCloseBarButtonItem(_:)))
    }

    interactor?.viewDidLoad()
  }

  override func makeCollectionView() -> CollectionView {
    let collectionView = super.makeCollectionView()
    collectionView.backgroundColor = .mainBackground
    collectionView.delaysContentTouches = false
    collectionView.scrollDelegate = self
    return collectionView
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
      self.setSections(self.sections, animated: false)
    })
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    noteButton.layer.cornerRadius = noteButton.bounds.width / 2
    moreButton.layer.cornerRadius = moreButton.bounds.width / 2
  }

  // MARK: Private

  private let noteButton = UIButton(type: .system)
  private let moreButton = UIButton(type: .system)

  private var viewModel: WineDetailViewModel = .init(navigationTitle: nil, sections: [], isGeneralInfoCollapsed: false)

  @SectionModelBuilder
  private var sections: [SectionModel] {
    viewModel.sections.compactMap({ section in
      switch section {
      case .gallery(let itemID, let content):
        return SectionModel(dataID: section.dataID) {
          GalleryView.itemModel(
            dataID: itemID,
            content: content,
            style: .init())
            .flowLayoutItemSize(.init(width: collectionView.frame.width, height: GalleryView.height))
        }
        .flowLayoutSectionInset(.init(top: 0, left: 0, bottom: 16, right: 0))

      case .name(let itemID, let content):
        let width: CGFloat = collectionView.frame.width - 48
        let height: CGFloat = Label.height(
          for: content,
          width: width,
          style: .style(with: .lagerTitle))
        return SectionModel(dataID: section.dataID) {
          Label.itemModel(
            dataID: itemID,
            content: content,
            style: .style(with: .lagerTitle))
        }
        .flowLayoutItemSize(.init(width: width, height: height))
        .flowLayoutSectionInset(.init(top: 8, left: 24, bottom: 8, right: 24))

      case .title(let itemID, let content):
        let width: CGFloat = collectionView.frame.width - 48
        let height: CGFloat = Label.height(
          for: content,
          width: width,
          style: .style(with: .lagerTitle))
        return SectionModel(dataID: section.dataID) {
          Label.itemModel(
            dataID: itemID,
            content: content,
            style: .style(with: .lagerTitle))
        }
        .flowLayoutItemSize(.init(width: width, height: height))
        .flowLayoutSectionInset(.init(top: 16, left: 24, bottom: 8, right: 24))

      case .rate(let itemID, let content):
        let width: CGFloat = collectionView.frame.width - 48
        return SectionModel(dataID: section.dataID) {
          StarRatingControlView.itemModel(
            dataID: itemID,
            content: content,
            style: .init())
            .setBehaviors { [weak self] context in
              context.view.delegate = self
            }
        }
        .flowLayoutItemSize(.init(width: width, height: StarRatingControlView.height))
        .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 16, right: 24))

      case .winery(let itemID, let content):
        let width: CGFloat = collectionView.frame.width - 48
        let height: CGFloat = Label.height(
          for: content,
          width: width,
          style: .style(with: .subtitle))
        return SectionModel(dataID: section.dataID) {
          Label.itemModel(
            dataID: itemID,
            content: content,
            style: .style(with: .subtitle))
        }
        .flowLayoutItemSize(.init(width: width, height: height))
        .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 0, right: 24))

      case .text(let itemID, let content):
        let width: CGFloat = collectionView.frame.width - 48
        let height: CGFloat = Label.height(
          for: content,
          width: width,
          style: .style(with: .miniBold, textAligment: .center))
        return SectionModel(dataID: section.dataID) {
          Label.itemModel(
            dataID: itemID,
            content: content,
            style: .style(with: .miniBold, textAligment: .center))
        }
        .flowLayoutItemSize(.init(width: width, height: height))
        .flowLayoutSectionInset(.init(top: 8, left: 24, bottom: 16, right: 24))

      case .tool(let itemID, let content):
        let width: CGFloat = collectionView.frame.width - 48
        return SectionModel(dataID: section.dataID) {
          ToolView.itemModel(
            dataID: itemID,
            content: content,
            style: .init())
            .setBehaviors { [weak self] context in
              context.view.delegate = self
            }
        }
        .flowLayoutItemSize(.init(width: width, height: ToolView.height))
        .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 16, right: 24))

      case .list(let itemID, let rows):
        let width: CGFloat = collectionView.frame.width
        return SectionModel(
          dataID: section.dataID,
          items: rows.enumerated().compactMap({ index, content in
            TitleWithSubtitleInfoView.itemModel(
              dataID: itemID.rawValue + String(index),
              content: content,
              style: .init(backgroundColor: index.isMultiple(of: 2) ? .option : .mainBackground))
              .flowLayoutItemSize(.init(width: width, height: TitleWithSubtitleInfoView.height(width: width, content: content)))
          }))
          .flowLayoutSectionInset(.zero)
          .flowLayoutMinimumLineSpacing(0)

      case .ratingAndReview(let itemID, let content):
        let width: CGFloat = collectionView.frame.width - 48
        let height: CGFloat = TitleAndMoreView.height(width: width, content: content)
        return SectionModel(dataID: section.dataID) {
          TitleAndMoreView.itemModel(
            dataID: itemID,
            content: content,
            style: .init())
            .setBehaviors { [weak self] context in
              context.view.delegate = self
            }
        }
        .flowLayoutItemSize(.init(width: width, height: height))
        .flowLayoutSectionInset(.init(top: 16, left: 24, bottom: 8, right: 24))

      case .reviews(let itemID, let content):
        return SectionModel(dataID: section.dataID) {
          ReviewsCollectionView.itemModel(
            dataID: itemID,
            content: content,
            behaviors: .init(didTap: { [weak self] reviewID in
              self?.interactor?.didTapReview(reviewID: reviewID)
            }),
            style: .init())
        }
        .flowLayoutItemSize(.init(width: collectionView.frame.width, height: 200))
        .flowLayoutSectionInset(.init(top: 0, left: 0, bottom: 16, right: 0))

      case .servingTips(let itemID, let content):
        return SectionModel(dataID: section.dataID) {
          ServingTipsCollectionView.itemModel(
            dataID: itemID,
            content: content,
            style: .init())
        }
        .flowLayoutItemSize(.init(width: collectionView.frame.width, height: 100))
        .flowLayoutSectionInset(.init(top: 0, left: 0, bottom: 8, right: 0))

      case .button(let itemID, let content):
        let width: CGFloat = collectionView.frame.width - 48
        return SectionModel(dataID: section.dataID) {
          ButtonView.itemModel(
            dataID: itemID,
            content: content,
            style: .init())
            .setBehaviors { [weak self] context in
              context.view.delegate = self
            }
        }
        .flowLayoutItemSize(.init(width: width, height: ButtonView.height))
        .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 16, right: 24))

      case .ad(let itemID):
        return SectionModel(dataID: section.dataID) {
          AdItemView.itemModel(
            dataID: itemID,
            content: .init(),
            style: .init())
            .setBehaviors { [weak self] context in
              context.view.adBanner.rootViewController = self
            }
            .flowLayoutItemSize(.init(width: collectionView.frame.width, height: AdItemView.height))
        }

      case .similarWines(let itemID, let content):
        return SectionModel(dataID: section.dataID) {
          BottlesCollectionView.itemModel(
            dataID: itemID,
            content: content,
            behaviors: .init(didTap: { [weak self] wineID in
              self?.interactor?.didTapSimilarWine(wineID: wineID)
            }),
            style: .init())
        }
        .flowLayoutItemSize(.init(width: collectionView.frame.width, height: 250))
        .flowLayoutSectionInset(.init(top: 0, left: 0, bottom: 16, right: 0))

      case .expandCollapse(let itemID, let content):
        return SectionModel(dataID: section.dataID) {
          ExpandCollapseView.itemModel(
            dataID: itemID,
            content: content,
            style: .init())
            .didSelect { [weak self] _ in
              self?.interactor?.didTapExpandOrCollapseGeneralInfo()
            }
            .flowLayoutItemSize(.init(width: collectionView.frame.width, height: 44))
        }

      case .whereToBuy(let itemID, let rows):
        let width: CGFloat = collectionView.frame.width
        return SectionModel(
          dataID: section.dataID,
          items: rows.enumerated().compactMap({ index, content in
            WhereToBuyView.itemModel(
              dataID: itemID.rawValue + String(index),
              content: content,
              style: .init(backgroundColor: index.isMultiple(of: 2) ? .option : .mainBackground))
              .flowLayoutItemSize(.init(width: width, height: WhereToBuyView.height(width: width, content: content)))
              .didSelect { [weak self] _ in
                self?.interactor?.didSelectStore(affilatedId: content.affilatedId)
              }
          }))
          .flowLayoutSectionInset(.zero)
          .flowLayoutMinimumLineSpacing(0)
      }
    })
  }

  private var activeRect: CGRect {
    let headerRect = CGRect.zero //headerView.convert(headerView.bounds, to: view)
    let collectionViewRect = collectionView.convert(collectionView.safeAreaLayoutGuide.layoutFrame, to: view)
    let activeRectTopLeft = CGPoint(x: collectionViewRect.origin.x, y: headerRect.origin.y + headerRect.size.height)
    let activeRectBottomRight = CGPoint(x: collectionViewRect.origin.x + collectionViewRect.size.width, y: collectionViewRect.origin.y + collectionViewRect.size.height)
    return CGRect(origin: activeRectTopLeft, size: CGSize(width: activeRectBottomRight.x - activeRectTopLeft.x, height: activeRectBottomRight.y - activeRectTopLeft.y))
  }

  @objc
  private func didTapCloseBarButtonItem(_: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }

  @objc
  private func didTapNotes(_: UIButton) {
    interactor?.didTapNotes()
  }

  @objc
  private func didTapMore(_ button: UIButton) {
    interactor?.didTapMore(button)
  }

  private func showDeliveryTutorialIfCan(at indexPath: IndexPath, collectionCell: UICollectionViewCell, viewModel: DeliveryTutorialViewModel) {
    let point = collectionCell.convert(
      CGPoint(x: collectionCell.contentView.frame.minX, y: collectionCell.contentView.frame.maxY + 8),
      to: nil)
    let size = collectionCell.contentView.frame.size
    let sourceViewFrame = CGRect(origin: point, size: size)
    guard
      presentDeliveryTutorialView(
        viewModel: viewModel,
        sourceViewFrame: sourceViewFrame) else { return }
    interactor?.didShowTutorial()
  }

  private func presentDeliveryTutorialView(
    viewModel: DeliveryTutorialViewModel,
    sourceViewFrame: CGRect)
    -> Bool
  {
    let availiableWidth = collectionView.bounds.size.width - 48
    guard
      let tutorialViewController = TutorialViewController.build(
        with: viewModel,
        sourceViewFrame: sourceViewFrame,
        availiableWidth: availiableWidth,
        activeRect: activeRect)
    else {
      return false
    }
    presentationCenter?.presentViewController(tutorialViewController, animated: true, completion: nil)
    return true
  }
}

// MARK: UIScrollViewDelegate

extension WineDetailViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    navigationItem.title = scrollView.contentOffset.y > 300 ? viewModel.navigationTitle : nil
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    interactor?.didScrollStopped()
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      interactor?.didScrollStopped()
    }
  }
}

// MARK: ButtonCollectionCellDelegate

extension WineDetailViewController: ButtonCollectionCellDelegate {
  func didTapReviewButton(_: UIButton) {
    interactor?.didTapWriteReviewButton()
  }
}

// MARK: ToolCollectionCellDelegate

extension WineDetailViewController: ToolCollectionCellDelegate {
  func didTapShare(_ button: UIButton) {
    interactor?.didTapShareButton(button)
  }

  func didTapLike(_ button: UIButton) {
    interactor?.didTapLikeButton(button)
  }

  func didTapPrice(_: UIButton) {
    interactor?.didTapPriceButton()
  }
}

// MARK: WineDetailViewControllerProtocol

extension WineDetailViewController: WineDetailViewControllerProtocol {

  func showReviewButtonTutorial(viewModel: DeliveryTutorialViewModel) {
    for visibleCell in collectionView.visibleCells {
      guard
        let indexPath = collectionView.indexPath(for: visibleCell),
        let restaurantCell = (visibleCell as? CollectionViewCell),
        restaurantCell.view as? ButtonView != nil
      else { continue }
      showDeliveryTutorialIfCan(at: indexPath, collectionCell: restaurantCell, viewModel: viewModel)
    }
  }

  func updateGeneralInfoSectionAndExpandOrCollapseCell(viewModel: WineDetailViewModel) { // TODO: - only updateUI
    self.viewModel = viewModel
    collectionView.setSections(sections, animated: true)
  }

  func updateUI(viewModel: WineDetailViewModel) {
    self.viewModel = viewModel
    collectionView.setSections(sections, animated: true)
  }
}

// MARK: TitleAndMoreViewDelegate

extension WineDetailViewController: TitleAndMoreViewDelegate {
  func didTapSeeAllReview() {
    interactor?.didTapSeeAllReviews()
  }
}

// MARK: AuthorizationOutputDelegate

extension WineDetailViewController: AuthorizationOutputDelegate {
  func didSuccessfullyLogin(output _: AuthorizationOutputModel?) {
    interactor?.didSuccessfullyLoginOrRegister()
  }

  func didSuccessfullyRegister(output _: AuthorizationOutputModel?) {
    interactor?.didSuccessfullyLoginOrRegister()
  }
}

// MARK: StarRatingControlCollectionCellDelegate

extension WineDetailViewController: StarRatingControlCollectionCellDelegate {
  func didTapStarRatingControl() {
    interactor?.didTapStarsRatingControl()
  }
}
