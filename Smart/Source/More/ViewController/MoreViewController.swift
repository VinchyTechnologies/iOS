//
//  MoreViewController.swift
//  Coffee
//
//  Created by Алексей Смирнов on 10/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//

import CommonUI
import Display
import StringFormatting
import UIKit
import VinchyAuthorization

// MARK: - C

private enum C {
  static let horizontalInset: CGFloat = 16
}

// MARK: - MoreViewController

final class MoreViewController: UIViewController {

  // MARK: Internal

  var interactor: MoreInteractorProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(collectionView)
    collectionView.fill()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
    interactor?.viewDidLoad() // TODO: - incorrect logic
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
      self.collectionView.collectionViewLayout.invalidateLayout()
    })
  }

  // MARK: Private

  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .mainBackground
    collectionView.register(
      ProfileCell.self,
      ContactCell.self,
      RateAppCell.self,
      InfoCurrencyCell.self,
      DocCell.self,
      TextCollectionCell.self,
      SeparatorCell.self,
      LogOutCell.self,
      SocialMediaCell.self)

    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)

    return collectionView
  }()

  private var viewModel: MoreViewControllerModel? {
    didSet {
      navigationItem.title = viewModel?.navigationTitle
      collectionView.reloadData()
    }
  }
}

// MARK: UICollectionViewDataSource

extension MoreViewController: UICollectionViewDataSource {
  func numberOfSections(in _: UICollectionView) -> Int {
    viewModel?.sections.count ?? 0
  }

  func collectionView(
    _: UICollectionView,
    numberOfItemsInSection section: Int)
    -> Int
  {
    switch viewModel?.sections[safe: section] {
    case .profile(let model):
      return model.count

    case .header(let model):
      return model.count

    case .phone(let model), .email(let model), .partner(let model):
      return model.count

    case .rate(let model):
      return model.count

    case .currency(let model):
      return model.count

    case .social(let model):
      return model.count

    case .doc(let model), .aboutApp(let model):
      return model.count

    case .separator:
      return 1

    case .logout(let model):
      return model.count

    case .none:
      return 0
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    let section = viewModel?.sections[indexPath.section]
    switch section {
    case .profile(let model):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.reuseId, for: indexPath) as! ProfileCell // swiftlint:disable:this force_cast
      cell.decorate(model: model[indexPath.row])
      return cell

    case .header(let model):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionCell.reuseId, for: indexPath) as! TextCollectionCell // swiftlint:disable:this force_cast
      cell.decorate(model: model[indexPath.row])
      return cell

    case .phone(let model), .email(let model), .partner(let model):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactCell.reuseId, for: indexPath) as! ContactCell // swiftlint:disable:this force_cast
      cell.decorate(model: model[indexPath.row])
      return cell

    case .rate(let model):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RateAppCell.reuseId, for: indexPath) as! RateAppCell // swiftlint:disable:this force_cast
      cell.decorate(model: model[indexPath.row])
      return cell

    case .currency(let model):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCurrencyCell.reuseId, for: indexPath) as! InfoCurrencyCell // swiftlint:disable:this force_cast
      cell.decorate(model: model[indexPath.row])
      return cell

    case .social(let model):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SocialMediaCell.reuseId, for: indexPath) as! SocialMediaCell // swiftlint:disable:this force_cast
      cell.decorate(model: model[indexPath.row])
      cell.delegate = self
      return cell

    case .doc(let model), .aboutApp(let model):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DocCell.reuseId, for: indexPath) as! DocCell // swiftlint:disable:this force_cast
      cell.decorate(model: model[indexPath.row])
      return cell

    case .separator:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeparatorCell.reuseId, for: indexPath) as! SeparatorCell // swiftlint:disable:this force_cast
      return cell

    case .logout(let model):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LogOutCell.reuseId, for: indexPath) as! LogOutCell // swiftlint:disable:this force_cast
      cell.decorate(model: model[indexPath.row])
      return cell

    case .none:
      fatalError()
    }
  }
}

// MARK: UICollectionViewDelegateFlowLayout

extension MoreViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout _: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath)
    -> CGSize
  {
    switch viewModel?.sections[safe: indexPath.section] {
    case .profile:
      let width = collectionView.frame.width
      return CGSize(width: width, height: ProfileCell.height())

    case .header(let model):
      let width = collectionView.frame.width - 2 * C.horizontalInset
      return CGSize(width: width, height: TextCollectionCell.height(viewModel: model[indexPath.row], width: width))

    case .phone, .email, .partner:
      let width = collectionView.frame.width
      return CGSize(width: width, height: ContactCell.height())

    case .rate:
      let width = collectionView.frame.width
      return CGSize(width: width, height: RateAppCell.height())

    case .currency:
      let width = collectionView.frame.width
      return CGSize(width: width, height: InfoCurrencyCell.height())

    case .social:
      let width = collectionView.frame.width
      return CGSize(width: width, height: SocialMediaCell.height())

    case .doc, .aboutApp:
      let width = collectionView.frame.width
      return CGSize(width: width, height: DocCell.height())

    case .separator:
      return .init(width: collectionView.frame.width, height: 1)

    case .logout:
      return .init(width: collectionView.frame.width, height: LogOutCell.height())

    case .none:
      return .zero
    }
  }

  func collectionView(
    _: UICollectionView,
    layout _: UICollectionViewLayout,
    insetForSectionAt section: Int)
    -> UIEdgeInsets
  {
    switch viewModel?.sections[safe: section] {
    case .header:
      return .init(top: 0, left: C.horizontalInset, bottom: 0, right: C.horizontalInset)

    case .separator:
      return .init(top: 0, left: 0, bottom: 10, right: 0)

    case .profile, .phone, .email, .partner, .rate, .currency, .social, .doc, .aboutApp, .none, .logout:
      return .zero
    }
  }

  func collectionView(
    _: UICollectionView,
    didSelectItemAt indexPath: IndexPath)
  {
    switch viewModel?.sections[indexPath.section] {
    case .profile:
      interactor?.didTapProfile()

    case .header:
      break

    case .phone:
      interactor?.didTapCallUs()

    case .email:
      guard let sourceView = collectionView.cellForItem(at: indexPath) else {
        return
      }
      interactor?.didTapEmailUs(sourceView: sourceView)

    case .partner:
      guard let sourceView = collectionView.cellForItem(at: indexPath) else {
        return
      }
      interactor?.didTapworkWithUs(sourceView: sourceView)

    case .rate:
      interactor?.didTapRateApp()

    case .currency:
      interactor?.didTapCurrency()

    case .doc:
      interactor?.didTapDoc()

    case .aboutApp:
      interactor?.didTapAboutApp()

    case .social, .separator:
      break

    case .logout:
      interactor?.didTapLogout()

    case .none:
      fatalError()
    }
  }
}

// MARK: MoreViewControllerProtocol

extension MoreViewController: MoreViewControllerProtocol {
  func updateUI(viewModel: MoreViewControllerModel) {
    self.viewModel = viewModel
  }
}

// MARK: AuthorizationOutputDelegate

extension MoreViewController: AuthorizationOutputDelegate {
  func didSuccessfullyRegister(output: AuthorizationOutputModel?) {
    interactor?.viewDidLoad()
  }

  func didSuccessfullyLogin(output: AuthorizationOutputModel?) {
    ratesRepository.state = .needsReload
    interactor?.viewDidLoad()
  }
}

// MARK: ScrollableToTop

extension MoreViewController: ScrollableToTop {
  var scrollableToTopScrollView: UIScrollView {
    collectionView
  }
}

// MARK: SocialMediaCellDelegate

extension MoreViewController: SocialMediaCellDelegate {
  func didTapInstagram() {
    interactor?.didTapOpenInstagram()
  }

  func didTapTelegram() {
    interactor?.didTapOpenTelegram()
  }

  func didTapFacebook() {
    interactor?.didTapOpenFacebook()
  }
}
