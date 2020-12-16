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

final class MoreViewController: UIViewController {

  var interactor: MoreInteractorProtocol?
  
  private var viewModel: MoreViewControllerModel? {
    didSet {
      navigationItem.title = viewModel?.navigationTitle
      collectionView.reloadData()
    }
  }

  private var collectionView: UICollectionView {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
    collectionView.backgroundColor = .mainBackground
    collectionView.register(
      ContactCell.self,
      RateAppCell.self,
      DocCell.self,
      TextCollectionCell.self)
    
    collectionView.dataSource = self
    collectionView.delegate = self

    return collectionView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(collectionView)
    collectionView.fill()
    interactor?.viewDidLoad()
  }
}

extension MoreViewController: SocialMediaCellDelegate {
  func didClickVK() {
    interactor?.openVk()
  }
  
  func didClickInstagram() {
    interactor?.openInstagram()
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
    case .header(let model):
      return model.count
      
    case .phone(let model), .email(let model), .partner(let model):
      return model.count
      
    case .rate(let model):
      return model.count
      
    case .social(let model):
      return model.count
      
    case .doc(let model):
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
      
    case .doc(let model):
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
    case .header(let model):
      let width = collectionView.frame.width
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

    case .doc:
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
      return .init(top: 0, left: 16, bottom: 0, right: 16)

    case .phone, .email, .partner:
      return .init(top: 0, left: 16, bottom: 0, right: 16)

    case .rate:
      return .init(top: 0, left: 16, bottom: 0, right: 16)

    case .social:
      return .init(top: 0, left: 16, bottom: 0, right: 16)

    case .doc:
      return .init(top: 0, left: 16, bottom: 0, right: 16)

    case .none:
      return .zero
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath)
  {

    switch viewModel?.sections[indexPath.section] {

    case .header:
      break

    case .phone:
      interactor?.callUs()

    case .email:
      interactor?.emailUs()

    case .partner:
      interactor?.workWithUs()

    case .rate:
      interactor?.rateApp()

    case .doc:
      interactor?.goToDocController()

    default:
      return

//    case .none:
//      break

    }

//      switch (viewModel.sections[indexPath.section], indexPath.row) {
//      case (.contact, 0):
//        interactor?.callUs()
//      case (.contact, 1):
//        interactor?.emailUs()
//      case (.contact, 2):
//        interactor?.workWithUs()
//      case (.rate, _):
//        interactor?.rateApp()
//      case (.doc, 0):
//        interactor?.goToDocController()
//      case (.doc, 1):
//        interactor?.goToAboutController()
//      case (_, _):
//        break
//    }
  }
}

extension MoreViewController: MoreViewProtocol {
  
  func updateUI(viewModel: MoreViewControllerModel) {
    self.viewModel = viewModel
  }
}
