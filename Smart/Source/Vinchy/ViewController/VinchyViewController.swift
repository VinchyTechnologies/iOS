//
//  VinchyViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import VinchyCore
import Display
import CommonUI
import Core
import EmailService
import StringFormatting
// swiftlint:disable:force_cast

fileprivate enum C {
  static let horizontalInset: CGFloat = 16
}

final class VinchyViewController: UIViewController {

  // MARK: - Public Properties

  var interactor: VinchyInteractorProtocol?

  // MARK: - Private Properties

  /// Restoration state for UISearchController
  private var restoredState = SearchControllerRestorableState()

  private var sections = [VinchyViewControllerViewModel.Section]() {
    didSet {
      collectionView.reloadData()
    }
  }

  private(set) var loadingIndicator = ActivityIndicatorView()

  private let keyboardHelper = KeyboardHelper()

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
      TextCollectionCell.self)

    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.refreshControl = refreshControl
    collectionView.delaysContentTouches = false
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

  private var isSearchingMode: Bool = false {
    didSet {
      if oldValue != isSearchingMode {
        collectionView.reloadData()
      }
      if isSearchingMode {
        refreshControl.removeFromSuperview()
      } else {
        collectionView.refreshControl = refreshControl
      }
    }
  }

  private var suggestions: [Wine] = []

  private lazy var bottomConstraint = NSLayoutConstraint(
    item: collectionView,
    attribute: .bottom,
    relatedBy: .equal,
    toItem: view,
    attribute: .bottom,
    multiplier: 1,
    constant: 0)

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    
    definesPresentationContext = true

    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      bottomConstraint,
    ])

    let filterBarButtonItem = UIBarButtonItem(
      image: UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate),
      style: .plain,
      target: self,
      action: #selector(didTapFilter))
    navigationItem.rightBarButtonItems = [filterBarButtonItem]
    navigationItem.searchController = searchController

    refreshControl.tintColor = .dark
    refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)

    configureKeyboardHelper()

    interactor?.viewDidLoad()

  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    // Restore the searchController's active state.
    if restoredState.wasActive {
      searchController.isActive = restoredState.wasActive
      restoredState.wasActive = false

      if restoredState.wasFirstResponder {
        searchController.searchBar.becomeFirstResponder()
        restoredState.wasFirstResponder = false
      }
    }
  }

  private func configureKeyboardHelper() {
    keyboardHelper.bindBottomToKeyboardFrame(
      animated: true,
      animate: { [weak self] height in
        self?.updateNextButtonBottomConstraint(with: height)
      })
  }

  public func updateNextButtonBottomConstraint(with keyboardHeight: CGFloat) {

    defer {
      view.layoutSubviews()
    }

    if keyboardHeight == 0 {
      (searchController.searchResultsController as? ResultsTableController)?.set(constant: .zero)
      bottomConstraint.constant = .zero
      return
    }

    (searchController.searchResultsController as? ResultsTableController)?.set(constant: -keyboardHeight)
    bottomConstraint.constant = -keyboardHeight

  }

  // MARK: - Private Methods

  @objc
  private func didTapFilter() {
    interactor?.didTapFilter()
  }

  @objc
  private func didPullToRefresh() {
    if !isSearchingMode {
      CATransaction.begin()
      CATransaction.setCompletionBlock {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          self.refreshControl.endRefreshing()
        }
      }
      interactor?.didPullToRefresh()
      CATransaction.commit()
    }
  }
}

// MARK: - UICollectionViewDataSource

extension VinchyViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int)
  -> CGFloat
  {
    isSearchingMode ? 0 : 10
  }

  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath) {

    if isSearchingMode {
      let wineID = suggestions[indexPath.row].id
      navigationController?.pushViewController(Assembly.buildDetailModule(wineID: wineID), animated: true)
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath)
  -> CGSize
  {
    if isSearchingMode {
      return .init(width: collectionView.frame.width, height: 44)
    }

    switch sections[indexPath.section] {
    case .title(let model):
      let width = collectionView.frame.width - 2 * C.horizontalInset
      let height = TextCollectionCell.height(viewModel: model[indexPath.row], width: width)
      return .init(width: width, height: height)

    case .stories(let model), .promo(let model), .big(let model), .bottles(let model):
      return .init(width: collectionView.frame.width,
                   height: VinchySimpleConiniousCaruselCollectionCell.height(viewModel: model[safe: indexPath.row]))

    case .suggestions(_):
      return .init(width: collectionView.frame.width, height: 44)

    case .shareUs(_):
      let width = collectionView.frame.width - 2 * C.horizontalInset
      let height: CGFloat = 150 // TODO: -
      return .init(width: width, height: height)
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int)
  -> UIEdgeInsets
  {
    if isSearchingMode {
      return .init(top: 0, left: C.horizontalInset, bottom: 0, right: C.horizontalInset)
    }

    switch sections[section] {
    case .title:
      return .init(top: 10, left: C.horizontalInset, bottom: 5, right: C.horizontalInset)

    case .suggestions:
      return .init(top: 0, left: C.horizontalInset, bottom: 0, right: C.horizontalInset)

    case .shareUs:
      return .init(top: 15, left: C.horizontalInset, bottom: 10, right: C.horizontalInset)

    case .stories, .promo, .big, .bottles:
      return .zero
    }
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    isSearchingMode ? 1 : sections.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if isSearchingMode {
      return suggestions.count
    } else {
      switch sections[section] {
      case .title(let model):
        return model.count

      case .stories(let model), .promo(let model), .big(let model), .bottles(let model):
        return model.count

      case .suggestions(let model):
        return model.count

      case .shareUs(let model):
        return model.count
      }
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath)
  -> UICollectionViewCell
  {

    if isSearchingMode {
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestionCollectionCell.reuseId, for: indexPath) as! SuggestionCollectionCell
      cell.decorate(model: .init(titleText: suggestions[indexPath.row].title))
      return cell
    }

    switch sections[indexPath.section] {
    case .title(let model):
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionCell.reuseId, for: indexPath) as! TextCollectionCell
      cell.decorate(model: model[indexPath.row])
      return cell

    case .stories(let model), .promo(let model), .big(let model), .bottles(let model):
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: VinchySimpleConiniousCaruselCollectionCell.reuseId,
        for: indexPath) as! VinchySimpleConiniousCaruselCollectionCell// swiftlint:disable:this force_cast
      cell.decorate(model: model[indexPath.row])
      cell.delegate = self
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
    }

    //            case .smartFilter:
    //                // swiftlint:disable:next force_cast
    //                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmartFilterCollectionCell.reuseId, for: indexPath) as! SmartFilterCollectionCell
    //                cell.decorate(model: .init(
    //                                accentText: "New in Vinchy".uppercased(),
    //                                boldText: "Personal compilations",
    //                                subtitleText: "Answer on 3 questions & we find for you best wines.",
    //                                buttonText: "Try now"))
  }
}

extension VinchyViewController: UISearchBarDelegate {

  func searchBar(
    _ searchBar: UISearchBar,
    textDidChange searchText: String) {

    interactor?.didEnterSearchText(searchText)
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    interactor?.didTapSearchButton(searchText: searchBar.text)
  }

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    isSearchingMode = true
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    isSearchingMode = false
  }
}

extension VinchyViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let wineID = (searchController.searchResultsController as? ResultsTableController)?.getWines()[safe: indexPath.row]?.id else { return }
    navigationController?.pushViewController(Assembly.buildDetailModule(wineID: wineID), animated: true)
  }
}

extension VinchyViewController: DidnotFindTheWineTableCellProtocol {

  func didTapWriteUsButton(_ button: UIButton) {

    let searchText = searchController.searchBar.searchTextField.text
    interactor?.didTapDidnotFindWineFromSearch(
      searchText: searchText)
  }
}

extension VinchyViewController: VinchySimpleConiniousCaruselCollectionCellDelegate {

  func didTapBootleCell(wineID: Int64) {

    navigationController?.pushViewController(Assembly.buildDetailModule(wineID: wineID), animated: true)
  }

  func didTapCompilationCell(wines: [Wine], title: String?) {

    guard !wines.isEmpty else {
      showAlert(message: localized("empty_collection"))
      return
    }

    navigationController?.pushViewController(
      Assembly.buildShowcaseModule(navTitle: title, mode: .normal(wines: wines)), animated: true)
  }
}

extension VinchyViewController: VinchyViewControllerProtocol {

  func updateUI(didFindWines: [Wine]) {
    (searchController.searchResultsController as? ResultsTableController)?.set(wines: didFindWines)
  }

  func updateUI(sections: [VinchyViewControllerViewModel.Section]) {
    self.sections = sections
  }

  func updateSearchSuggestions(suggestions: [Wine]) {
    self.suggestions = suggestions
  }
}

extension VinchyViewController: ShareUsCollectionCellDelegate {

  func didTapShareUs(_ button: UIButton) {
    let items = [localized("i_use_vinchy"), openAppStoreURL]
    let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
    present(controller, animated: true)
  }
}

//@objc private func didTapCamera() {
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
//}

extension VinchyViewController {

  /// State restoration values.
  enum RestorationKeys: String {
    case viewControllerTitle
    case searchControllerIsActive
    case searchBarText
    case searchBarIsFirstResponder
    case selectedScope
  }

  // State items to be restored in viewDidAppear().
  struct SearchControllerRestorableState {
    var wasActive = false
    var wasFirstResponder = false
  }

  override func encodeRestorableState(with coder: NSCoder) {
    super.encodeRestorableState(with: coder)

    // Encode the view state so it can be restored later.

    // Encode the title.
    coder.encode(
      navigationItem.title,
      forKey: RestorationKeys.viewControllerTitle.rawValue)

    // Encode the search controller's active state.
    coder.encode(
      searchController.isActive,
      forKey: RestorationKeys.searchControllerIsActive.rawValue)

    // Encode the first responser status.
    coder.encode(
      searchController.searchBar.isFirstResponder,
      forKey: RestorationKeys.searchBarIsFirstResponder.rawValue)

    // Encode the first responser status.
    coder.encode(
      searchController.searchBar.selectedScopeButtonIndex,
      forKey: RestorationKeys.selectedScope.rawValue)

    // Encode the search bar text.
    coder.encode(
      searchController.searchBar.text,
      forKey: RestorationKeys.searchBarText.rawValue)
  }

  override func decodeRestorableState(with coder: NSCoder) {
    super.decodeRestorableState(with: coder)

    // Restore the title.
    guard
      let decodedTitle = coder.decodeObject(forKey: RestorationKeys.viewControllerTitle.rawValue) as? String
    else {
      fatalError("A title did not exist. In your app, handle this gracefully.")
    }

    navigationItem.title = decodedTitle

    /** Restore the active and first responder state:
     We can't make the searchController active here since it's not part of the view hierarchy yet, instead we do it in viewDidAppear.
     */
    restoredState.wasActive = coder.decodeBool(forKey: RestorationKeys.searchControllerIsActive.rawValue)
    restoredState.wasFirstResponder = coder.decodeBool(forKey: RestorationKeys.searchBarIsFirstResponder.rawValue)

    // Restore the scope bar selection.
    searchController.searchBar.selectedScopeButtonIndex = coder.decodeInteger(forKey: RestorationKeys.selectedScope.rawValue)

    // Restore the text in the search field.
    searchController.searchBar.text = coder.decodeObject(forKey: RestorationKeys.searchBarText.rawValue) as? String
  }

}
