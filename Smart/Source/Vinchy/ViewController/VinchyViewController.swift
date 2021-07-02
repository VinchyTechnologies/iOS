//
//  VinchyViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Core
import Display
import FittedSheets
import StringFormatting
import UIKit
import VinchyCore

// MARK: - C

private enum C {
  static let horizontalInset: CGFloat = 16
}

// MARK: - VinchyViewController

final class VinchyViewController: UIViewController {

  // MARK: Internal

  var interactor: VinchyInteractorProtocol?

  private(set) var loadingIndicator = ActivityIndicatorView()

  override func viewDidLoad() {
    super.viewDidLoad()

    definesPresentationContext = true

    view.addSubview(collectionView)
    collectionView.fill()

    let filterBarButtonItem = UIBarButtonItem(
      image: UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate),
      style: .plain,
      target: self,
      action: #selector(didTapFilter))
    navigationItem.rightBarButtonItems = [filterBarButtonItem]
    navigationItem.searchController = searchController

    refreshControl.tintColor = .dark
    refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)

    if isMapOnVinchyVCAvailable {
      view.addSubview(mapButton)
      NSLayoutConstraint.activate([
        mapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        mapButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      ])
    }

    interactor?.viewDidLoad()

//    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//      let options = SheetOptions(shrinkPresentingViewController: false)
//      let controller = AreYouInStoreAssembly.assemblyModule(input: .init())
//
//      let bottomButtonsViewModel = BottomButtonsViewModel(
//        leadingButtonText: "Я не здесь",
//        trailingButtonText: "Смотреть ещё")
//
//      let viewModel = AreYouInStoreViewModel(
//        sections: [
//          .title([
//            .init(titleText: NSAttributedString(string: "Кажется, Вы в магазине \"Пятерочка\"?", font: Font.bold(24), textColor: .dark, paragraphAlignment: .center)),
//          ]),
//
    ////          .title([
    ////            .init(titleText: NSAttributedString(string: "Рекомендуем обратить внимание", font: Font.regular(16), textColor: .dark)),
    ////          ]),
//
//          .recommendedWines([
//            .init(type: .bottles, collections: [.init(wineList: [.wine(wine: ShortWine.fake)])]),
//          ]),
//        ],
//        bottomButtonsViewModel: bottomButtonsViewModel)
//
//      let height = AreYouInStoreViewController.height(viewModel: viewModel) // TODO: - input
//      let sheetController = SheetViewController(controller: controller, sizes: [.fixed(height)], options: options)
//      self.present(sheetController, animated: true, completion: nil)
//    }
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    if isMapOnVinchyVCAvailable {
      mapButton.layer.cornerRadius = mapButton.frame.height / 2
      mapButton.clipsToBounds = true
      collectionView.contentInset = .init(top: 0, left: 0, bottom: mapButton.frame.height + 16, right: 0)
    }
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
      self.collectionView.collectionViewLayout.invalidateLayout()
    })
  }

  // MARK: Private

  private lazy var mapButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .accent // UIColor(red: 121 / 255, green: 125 / 255, blue: 140 / 255, alpha: 1.0)
    button.setTitle("Map", for: .normal)
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold, scale: .default)
    button.setImage(UIImage(systemName: "map", withConfiguration: imageConfig), for: .normal)
    button.tintColor = .white
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = Font.bold(16)
    button.contentEdgeInsets = .init(top: 14, left: 18, bottom: 14, right: 18)
    button.imageEdgeInsets = .init(top: 0, left: -4, bottom: 0, right: 4)
    button.addTarget(self, action: #selector(didTapMapButton(_:)), for: .touchUpInside)
    return button
  }()

  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .vertical

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .mainBackground

    collectionView.register(
      SuggestionCollectionCell.self,
      VinchySimpleConiniousCaruselCollectionCell.self,
      ShareUsCollectionCell.self,
      WineCollectionViewCell.self,
      AdsCollectionViewCell.self,
      SmartFilterCollectionCell.self,
      TextCollectionCell.self,
      FakeVinchyCollectionCell.self)

    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.refreshControl = refreshControl
    collectionView.delaysContentTouches = false
    collectionView.keyboardDismissMode = .onDrag
    return collectionView
  }()

  private let refreshControl = UIRefreshControl()

  private lazy var searchController: UISearchController = {
    let resultsTableController = ResultsTableController()
    resultsTableController.set(delegate: self)
    resultsTableController.didnotFindTheWineTableCellDelegate = self

    let searchController = UISearchController(searchResultsController: resultsTableController)
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.autocapitalizationType = .none
    searchController.searchBar.delegate = self
    searchController.searchBar.searchTextField.font = Font.medium(20)
    searchController.searchBar.searchTextField.layer.cornerRadius = 20
    searchController.searchBar.searchTextField.layer.masksToBounds = true
    searchController.searchBar.searchTextField.layer.cornerCurve = .continuous
    return searchController
  }()

  private var suggestions: [Wine] = []

  private var viewModel: VinchyViewControllerViewModel = .init(state: .fake(sections: [])) {
    didSet {
      switch viewModel.state {
      case .fake:
        collectionView.isScrollEnabled = false

      case .normal:
        collectionView.isScrollEnabled = true
      }

      collectionView.reloadData()
    }
  }

  @objc
  private func didTapFilter() {
    interactor?.didTapFilter()
  }

  @objc
  private func didPullToRefresh() {
    interactor?.didPullToRefresh()
  }

  @objc
  private func didTapMapButton(_: UIButton) {
    interactor?.didTapMapButton()
  }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension VinchyViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _: UICollectionView,
    didSelectItemAt indexPath: IndexPath)
  {
    interactor?.didTapSuggestionCell(at: indexPath)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout _: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath)
    -> CGSize
  {
    switch viewModel.state {
    case .fake(let sections):
      let type: FakeVinchyCollectionCellViewModel?
      switch sections[safe: indexPath.section] {
      case .stories(let viewModel):
        type = viewModel

      case .promo(let viewModel):
        type = viewModel

      case .title(let viewModel):
        type = viewModel

      case .big(let viewModel):
        type = viewModel

      case .none:
        type = nil
      }

      let height = FakeVinchyCollectionCell.height(viewModel: type)
      return .init(width: collectionView.frame.width, height: height)

    case .normal(let sections):
      switch sections[indexPath.section] {
      case .title(let model):
        let width = collectionView.frame.width - 2 * C.horizontalInset
        let height = TextCollectionCell.height(viewModel: model[indexPath.row], width: width)
        return .init(width: width, height: height)

      case .stories(let model), .promo(let model), .big(let model), .bottles(let model):
        return .init(
          width: collectionView.frame.width,
          height: VinchySimpleConiniousCaruselCollectionCell.height(viewModel: model[safe: indexPath.row]))

      case .suggestions:
        return .init(width: collectionView.frame.width, height: 44)

      case .shareUs:
        let width = collectionView.frame.width - 2 * C.horizontalInset
        let height: CGFloat = 150 // TODO: -
        return .init(width: width, height: height)

      case .smartFilter:
        let width = collectionView.frame.width - 2 * C.horizontalInset
        let height: CGFloat = 170 // TODO: -
        return .init(width: width, height: height)
      }
    }
  }

  func collectionView(
    _: UICollectionView,
    layout _: UICollectionViewLayout,
    insetForSectionAt section: Int)
    -> UIEdgeInsets
  {
    switch viewModel.state {
    case .fake(let sections):
      switch sections[section] {
      case .stories, .big, .promo:
        return .zero

      case .title:
        return .init(top: 10, left: 0, bottom: 10, right: 0)
      }

    case .normal(let sections):
      switch sections[section] {
      case .title:
        return .init(top: 10, left: C.horizontalInset, bottom: 8, right: C.horizontalInset)

      case .suggestions:
        return .init(top: 0, left: C.horizontalInset, bottom: 0, right: C.horizontalInset)

      case .shareUs, .smartFilter:
        return .init(top: 15, left: C.horizontalInset, bottom: 10, right: C.horizontalInset)

      case .stories, .promo, .big, .bottles:
        return .zero
      }
    }
  }

  func numberOfSections(in _: UICollectionView) -> Int {
    switch viewModel.state {
    case .fake(let sections):
      return sections.count

    case .normal(let sections):
      return sections.count
    }
  }

  func collectionView(
    _: UICollectionView,
    numberOfItemsInSection section: Int)
    -> Int
  {
    switch viewModel.state {
    case .fake(let sections):
      switch sections[section] {
      case .stories, .promo, .title, .big:
        return 1
      }

    case .normal(sections: let sections):
      switch sections[section] {
      case .title(let model):
        return model.count

      case .stories(let model), .promo(let model), .big(let model), .bottles(let model):
        return model.count

      case .suggestions(let model):
        return model.count

      case .shareUs(let model):
        return model.count

      case .smartFilter(let model):
        return model.count
      }
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    switch viewModel.state {
    case .fake(let sections):
      switch sections[indexPath.section] {
      case .stories(let model), .promo(let model), .title(let model), .big(let model):
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FakeVinchyCollectionCell.reuseId, for: indexPath) as! FakeVinchyCollectionCell
        cell.decorate(model: model)
        return cell
      }

    case .normal(let sections):
      switch sections[indexPath.section] {
      case .title(let model):
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionCell.reuseId, for: indexPath) as! TextCollectionCell
        cell.decorate(model: model[indexPath.row])
        return cell

      case .stories(let model), .promo(let model), .big(let model), .bottles(let model):
        collectionView.register(
          VinchySimpleConiniousCaruselCollectionCell.self,
          forCellWithReuseIdentifier: VinchySimpleConiniousCaruselCollectionCell.reuseId + "\(indexPath.section)")

        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: VinchySimpleConiniousCaruselCollectionCell.reuseId + "\(indexPath.section)",
          for: indexPath) as! VinchySimpleConiniousCaruselCollectionCell // swiftlint:disable:this force_cast
        cell.decorate(model: model[indexPath.row])
        cell.delegate = interactor
        return cell

      case .suggestions(let model):
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestionCollectionCell.reuseId, for: indexPath) as! SuggestionCollectionCell
        cell.decorate(model: model[indexPath.row])
        return cell

      case .shareUs(let model):
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShareUsCollectionCell.reuseId, for: indexPath) as! ShareUsCollectionCell
        cell.decorate(model: model[indexPath.row])
        cell.delegate = self
        return cell

      case .smartFilter(let model):
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmartFilterCollectionCell.reuseId, for: indexPath) as! SmartFilterCollectionCell
        cell.decorate(model: model[indexPath.row])
        return cell
      }
    }
  }
}

// MARK: UISearchBarDelegate

extension VinchyViewController: UISearchBarDelegate {
  func searchBar(
    _: UISearchBar,
    textDidChange searchText: String)
  {
    interactor?.didEnterSearchText(searchText)
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    interactor?.didTapSearchButton(searchText: searchBar.text)
  }

  func searchBarTextDidBeginEditing(_: UISearchBar) {
    interactor?.searchBarTextDidBeginEditing()
  }

  func searchBarCancelButtonClicked(_: UISearchBar) {
    interactor?.searchBarCancelButtonClicked()
  }
}

// MARK: UITableViewDelegate

extension VinchyViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let wineID = (searchController.searchResultsController as? ResultsTableController)?.getWines()[safe: indexPath.row]?.id else { return }
    navigationController?.pushViewController(Assembly.buildDetailModule(wineID: wineID), animated: true)
  }
}

// MARK: DidnotFindTheWineTableCellProtocol

extension VinchyViewController: DidnotFindTheWineTableCellProtocol {
  func didTapWriteUsButton(_: UIButton) {
    let searchText = searchController.searchBar.searchTextField.text
    interactor?.didTapDidnotFindWineFromSearch(
      searchText: searchText)
  }
}

// MARK: VinchyViewControllerProtocol

extension VinchyViewController: VinchyViewControllerProtocol {
  func stopPullRefreshing() {
    refreshControl.endRefreshing()
  }

  func updateUI(didFindWines: [ShortWine]) {
    (searchController.searchResultsController as? ResultsTableController)?.set(wines: didFindWines)
  }

  func updateUI(viewModel: VinchyViewControllerViewModel) {
    self.viewModel = viewModel
  }

  func updateSearchSuggestions(suggestions: [Wine]) {
    self.suggestions = suggestions
  }
}

// MARK: ShareUsCollectionCellDelegate

extension VinchyViewController: ShareUsCollectionCellDelegate {
  func didTapShareUs(_ button: UIButton) {
    let items = [localized("i_use_vinchy"), localized("discovery_link")]
    let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
    if let popoverController = controller.popoverPresentationController {
      popoverController.sourceView = button
      popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
    }
    present(controller, animated: true)
  }
}

// @objc private func didTapCamera() {
//    if let window = view.window {
//        let transition = CATransition()
//        transition.duration = 0.35
//        transition.type = .push
//        transition.subtype = .fromLeft
//        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//        window.layer.add(transition, forKey: kCATransition)
//
//        let vc = VNDocumentCameraViewController()
//        vc.delegate = self
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: false, completion: nil)
//    }
// }
