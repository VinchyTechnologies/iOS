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

protocol MoreViewProtocol: AnyObject {
  func presentAlert(message: String)
}

final class MoreViewController: UIViewController, Alertable {
  
  private let refreshControl = UIRefreshControl()
  
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
      DocCell.self)
    
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.refreshControl = refreshControl
    collectionView.delaysContentTouches = false
    collectionView.keyboardDismissMode = .onDrag
    
    return collectionView
  }
  
  private lazy var viewModel: MoreViewControllerModel = {
    let contactPhoneViewModel = ContactCellViewModel(
      titleText: localized("contact_phone"),
      icon: UIImage(named: "phone"),
      detailText: localized("for_any_questions").firstLetterUppercased())
    let contactEmailViewModel = ContactCellViewModel(
      titleText: localized("contact_email"),
      icon: UIImage(systemName: "envelope.fill"),
      detailText: localized("email_us").firstLetterUppercased())
    let jobViewModel = ContactCellViewModel(
      titleText: localized("looking_for_partners").firstLetterUppercased(),
      icon: UIImage(named: "job"),
      detailText: localized("become_a_part_of_a_wine_startup").firstLetterUppercased())
    let rateViewModel = RateAppCellViewModel(
      titleText: localized("rate_our_app").firstLetterUppercased(),
      emojiLabel: "👍")
    let docViewModel = DocCellViewModel(
      titleText: localized("legal_documents").firstLetterUppercased(),
      icon: UIImage(named: "document"))
    let infoViewModel = DocCellViewModel(
      titleText: localized("about_the_app").firstLetterUppercased(),
      icon: UIImage(named: "info")?.withRenderingMode(.alwaysTemplate))
    
    let contactsSection = MoreViewControllerModel.Section.contact([contactPhoneViewModel, contactEmailViewModel, jobViewModel])
    let rateSection = MoreViewControllerModel.Section.rate([rateViewModel])
    let docsSection = MoreViewControllerModel.Section.doc([docViewModel, infoViewModel])
    return MoreViewControllerModel(sections: [contactsSection, rateSection, docsSection])
  }()
  
  var presenter: MorePresenterProtocol?
  private let configurator = MoreConfigurator()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configurator.configure(with: self)
    title = localized("info").firstLetterUppercased()
    definesPresentationContext = true
    view.addSubview(collectionView)
    collectionView.fill()
  }
}

extension MoreViewController: SocialMediaCellDelegate {
  func didClickVK() {
    presenter?.openVk()
  }
  
  func didClickInstagram() {
    presenter?.openInstagram()
  }
}

extension MoreViewController:  UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.sections.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int)
  -> Int
  {
    switch viewModel.sections[section] {
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
    case .contact (let model):
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactCell.reuseId, for: indexPath) as? ContactCell else {
        preconditionFailure("ContactCell can't to dequeued") }
      cell.decorate(model: model[indexPath.row])
      return cell
      
    case .rate (let model):
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RateAppCell.reuseId, for: indexPath) as? RateAppCell else {
        preconditionFailure("RateAppCell can't to dequeued") }
      cell.decorate(model: model[indexPath.row])
      return cell
      
    case .social(let model):
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SocialMediaCell.reuseId, for: indexPath) as? SocialMediaCell else {
        preconditionFailure("SocialMediaCell can't to dequeued") }
      cell.decorate(model: model[indexPath.row])
      return cell
      
    case .doc(let model):
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DocCell.reuseId, for: indexPath) as? DocCell else {
        preconditionFailure("DocCell can't to dequeued") }
      cell.decorate(model: model[indexPath.row])
      return cell
    }
  }
}

extension MoreViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionHeader {
      let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CartHeaderCollectionReusableView", for: indexPath)
      headerView.backgroundColor = .black
      
      return headerView
    }
    fatalError()
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let header = HeaderReusableView()
    header.decorate(model: .init(title: localized("always_available").firstLetterUppercased()))
    header.backgroundColor = .black
    return CGSize(width: view.frame.size.width, height: 50)
  }
  
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath)
  -> CGSize
  {
    switch viewModel.sections[indexPath.section] {
    case .contact(_):
      let width  = view.frame.width
      return CGSize(width: width, height: 60)
    case .rate(_):
      let width  = view.frame.width
      return CGSize(width: width, height: 150)
    case .social(_):
      let width  = view.frame.width
      return CGSize(width: width, height: 60)
    case .doc(_):
      let width  = view.frame.width
      return CGSize(width: width, height: 60)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if Locale.current.languageCode == "ru" {
      
      switch indexPath.row {
      case 0:
        presenter?.callUs()
      case 1:
        presenter?.emailUs()
      case 2:
        presenter?.workWithUs()
      case 3:
        presenter?.rateApp()
      case 4:
        presenter?.goToDocController()
      case 5:
        presenter?.goToAboutController()
      default:
        break
      }
    } else {
      switch indexPath.row {
      case 0:
        presenter?.emailUs()
      case 1:
        presenter?.workWithUs()
      case 2:
        presenter?.rateApp()
      case 3:
        presenter?.goToDocController()
      case 4:
        presenter?.goToAboutController()
      default:
        break
      }
    }
  }
}

extension MoreViewController: MoreViewProtocol {
  func presentAlert(message: String) {
    showAlert(message: message)
  }
}
