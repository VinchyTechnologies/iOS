//
//  MoreViewController.swift
//  Coffee
//
//  Created by Алексей Смирнов on 10/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//

import UIKit
import CommonUI
import StringFormatting
import Display

fileprivate enum C {
  static let horizontalInset: CGFloat = 16
}

final class MoreViewController: UIViewController {
  
  var interactor: MoreInteractorProtocol?
  
  private var viewModel: MoreViewControllerModel? {
    didSet {
      navigationItem.title = viewModel?.navigationTitle
      collectionView.reloadData()
    }
  }
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .mainBackground
    collectionView.register(
      ProfileCell.self,
      ContactCell.self,
      RateAppCell.self,
      DocCell.self,
      TextCollectionCell.self)
    
    collectionView.dataSource = self
    collectionView.delegate = self

    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(collectionView)
    collectionView.fill()
    interactor?.viewDidLoad()
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
        self.collectionView.collectionViewLayout.invalidateLayout()
    })
  }
}

extension MoreViewController: SocialMediaCellDelegate {
  func didClickVK() {
    interactor?.didTapOpenVk()
  }
  
  func didClickInstagram() {
    interactor?.didTapOpenInstagram()
  }
}

extension MoreViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    viewModel?.sections.count ?? 0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
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
      
    case .social(let model):
      return model.count
      
    case .doc(let model), .aboutApp(let model):
      return model.count
      
    case .none:
      return 0
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
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
      
    case .social(let model):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SocialMediaCell.reuseId, for: indexPath) as! SocialMediaCell // swiftlint:disable:this force_cast
      cell.decorate(model: model[indexPath.row])
      return cell
      
    case .doc(let model), .aboutApp(let model):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DocCell.reuseId, for: indexPath) as! DocCell // swiftlint:disable:this force_cast
      cell.decorate(model: model[indexPath.row])
      return cell
      
    case .none:
      fatalError()
    }
  }
}

extension MoreViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
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
      
    case .social:
      let width = collectionView.frame.width
      return CGSize(width: width, height: SocialMediaCell.height())
      
    case .doc, .aboutApp:
      let width = collectionView.frame.width
      return CGSize(width: width, height: DocCell.height())
      
    case .none:
      return .zero
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int)
    -> UIEdgeInsets
  {
    switch viewModel?.sections[safe: section] {
    case .header:
      return .init(top: 0, left: C.horizontalInset, bottom: 0, right: C.horizontalInset)

    case .profile, .phone, .email, .partner, .rate, .social, .doc, .aboutApp, .none:
      return .zero
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath)
  {
    switch viewModel?.sections[indexPath.section] {
    case .profile, .header:
      break
      
    case .phone:
      interactor?.didTapCallUs()
      
    case .email:
      interactor?.didTapEmailUs()
      
    case .partner:
      interactor?.didTapworkWithUs()
      
    case .rate:
      interactor?.didTapRateApp()
      
    case .doc:
      interactor?.didTapDoc()
      
    case .aboutApp:
      interactor?.didTapAboutApp()
      
    case .social:
      break
      
    case .none:
      fatalError()    
    }
  }
}

extension MoreViewController: MoreViewControllerProtocol {
  
  func updateUI(viewModel: MoreViewControllerModel) {
    self.viewModel = viewModel
  }
}
