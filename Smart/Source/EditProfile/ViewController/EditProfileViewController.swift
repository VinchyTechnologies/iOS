//
//  EditProfileViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 15.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display
import UIKit

final class EditProfileViewController: UIViewController {
  
  var interactor: EditProfileInteractorProtocol?
  
  private var viewModel: EditProfileViewModel? {
    didSet {
      navigationItem.title = viewModel?.navigationTitle
      saveButton.setTitle(viewModel?.saveButtonText, for: [])

      collectionView.reloadData()
    }
  }
  
  private let layout: UICollectionViewFlowLayout = {
    $0.scrollDirection = .vertical
    return $0
  }(UICollectionViewFlowLayout())
  
  private lazy var collectionView: UICollectionView = {
    $0.backgroundColor = .mainBackground
    $0.register(
      CommonEditCollectionViewCell.self,
      TextCollectionCell.self)
    $0.dataSource = self
    $0.delegate = self
    return $0
  }(UICollectionView(frame: .zero, collectionViewLayout: layout))
  
  private lazy var saveButton: Button = {
    $0.enable()
    return $0
  }(Button())
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.largeTitleDisplayMode = .never
    
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark", withConfiguration: imageConfig), style: .plain, target: self, action: #selector(didTapClose(_:)))
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
    
    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.fill()
    
    interactor?.viewDidLoad()
  }
  
  @objc
  private func didTapClose(_ barButtonItem: UIBarButtonItem) {
    dismiss(animated: true)
  }
}

// MARK: - EditProfileViewControllerProtocol

extension EditProfileViewController: EditProfileViewControllerProtocol {
  
  func updateUI(viewModel: EditProfileViewModel) {
    self.viewModel = viewModel
  }
}

// MARK: - UICollectionViewDataSource

extension EditProfileViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    viewModel?.sections.count ?? 0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int)
    -> Int
  {
    switch viewModel?.sections[safe: section] {
    case .commonEditCell(let models):
      return models.count
      
    case .none:
      return 0
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    switch viewModel?.sections[safe: indexPath.section] {
    case .commonEditCell(let models):
      let model = models[safe: indexPath.row]
      switch model {
      case .title(let text):
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionCell.reuseId, for: indexPath) as! TextCollectionCell
        cell.decorate(model: .init(titleText: text))
        return cell
        
      case .textField(let text):
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonEditCollectionViewCell.reuseId, for: indexPath) as! CommonEditCollectionViewCell
        cell.decorate(model: .init(recognizableIdentificator: nil, text: text, placeholder: "Add"))
        return cell
        
      case .none:
        return .init()
      }
      
    case .none:
      return .init()
    }
  }
}

// MARK: - UICollectionViewDelegate

extension EditProfileViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let width = collectionView.frame.width - 32
    switch viewModel?.sections[safe: indexPath.section] {
    case .commonEditCell(let models):
      let model = models[safe: indexPath.row]
      switch model {
      case .title(let text):
        let height = TextCollectionCell.height(viewModel: TextCollectionCell.ViewModel(titleText: text), width: width)
        return .init(width: width, height: height)
        
      case .textField:
        let height = CommonEditCollectionViewCell.height(for: nil)
        return .init(width: width, height: height)
        
      case .none:
        return .zero
      }
      
    case .none:
      return .zero
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int)
    -> CGFloat
  {
    0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int)
    -> UIEdgeInsets
  {
    UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
  }
}
