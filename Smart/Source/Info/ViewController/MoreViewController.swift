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
// swiftlint:disable all


final class MoreViewController: UIViewController, Alertable {
  
  private let refreshControl = UIRefreshControl()
  var interactor: MoreInteractorProtocol?
  
  var viewModel = MoreViewControllerModel(sections: [])
  
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
      HeaderCell.self)
    
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.refreshControl = refreshControl
    collectionView.delaysContentTouches = false
    collectionView.keyboardDismissMode = .onDrag
    
    return collectionView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = localized("info").firstLetterUppercased()
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

extension MoreViewController:  UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    viewModel.sections.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int)
  -> Int
  {
    
    switch viewModel.sections[section] {
    case .header(let model):
      return model.count
      
    case .contact(let model):
      return model.count
      
    case .rate(let model):
      return model.count
      
    case .social(let model):
      return model.count
      
    case .doc(let model):
      return model.count
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
  {
    
    let section = viewModel.sections[indexPath.section]
    switch section {
    case .header (let model):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCell.reuseId, for: indexPath) as? HeaderCell
      cell?.decorate(model: model[indexPath.row])
      return cell!
      
    case .contact (let model):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactCell.reuseId, for: indexPath) as? ContactCell
      cell?.decorate(model: model[indexPath.row])
      return cell!
      
    case .rate (let model):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RateAppCell.reuseId, for: indexPath) as? RateAppCell
      cell?.decorate(model: model[indexPath.row])
      return cell!
      
    case .social(let model):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SocialMediaCell.reuseId, for: indexPath) as? SocialMediaCell
      cell?.decorate(model: model[indexPath.row])
      return cell!
      
    case .doc(let model):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DocCell.reuseId, for: indexPath) as? DocCell
      cell?.decorate(model: model[indexPath.row])
      return cell!
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
    
    switch viewModel.sections[indexPath.section] {
    case .header(_):
      let width  = collectionView.frame.width
      return CGSize(width: width, height: HeaderCell.height())
    case .contact(_):
      let width  = collectionView.frame.width
      return CGSize(width: width, height: ContactCell.height())
    case .rate(_):
      let width  = collectionView.frame.width
      return CGSize(width: width, height: RateAppCell.height())
    case .social(_):
      let width  = collectionView.frame.width
      return CGSize(width: width, height: SocialMediaCell.height())
    case .doc(_):
      let width  = collectionView.frame.width
      return CGSize(width: width, height: DocCell.height())
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath)
  {
      switch (viewModel.sections[indexPath.section], indexPath.row) {
      case (.contact, 0):
        interactor?.callUs()
      case (.contact, 1):
        interactor?.emailUs()
      case (.contact, 2):
        interactor?.workWithUs()
      case (.rate, _):
        interactor?.rateApp()
      case (.doc, 0):
        interactor?.goToDocController()
      case (.doc, 1):
        interactor?.goToAboutController()
      case (_, _):
        break
    }
  }
}

extension MoreViewController: MoreViewProtocol {
  
  func updateUI(viewModel: MoreViewControllerModel) {
    self.viewModel = viewModel
    collectionView.reloadData()
  }
  
  func presentAlert(message: String) {
    showAlert(message: message)
  }
}
