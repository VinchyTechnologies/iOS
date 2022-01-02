//
//  EditProfileViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 15.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import UIKit

// MARK: - EditProfileViewController

final class EditProfileViewController: UIViewController {

  // MARK: Lifecycle

  init() {
    super.init(nibName: nil, bundle: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
  }

  required init?(coder: NSCoder) { fatalError() }

  // MARK: Internal

  var interactor: EditProfileInteractorProtocol?

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

  // MARK: Private

  private let layout: UICollectionViewFlowLayout = {
    $0.scrollDirection = .vertical
    return $0
  }(UICollectionViewFlowLayout())

  private lazy var collectionView: UICollectionView = {
    $0.backgroundColor = .mainBackground
    $0.register(
      CommonEditCollectionViewCell.self,
      TextCollectionCell.self,
      LogOutCell.self)
    $0.keyboardDismissMode = .onDrag
    $0.dataSource = self
    $0.delegate = self
    return $0
  }(UICollectionView(frame: .zero, collectionViewLayout: layout))

  private lazy var saveButton: Button = {
    $0.disable()
    $0.addTarget(self, action: #selector(didTapSaveButton(_:)), for: .touchUpInside)
    return $0
  }(Button())

  private var viewModel: EditProfileViewModel? {
    didSet {
      navigationItem.title = viewModel?.navigationTitle
      saveButton.setTitle(viewModel?.saveButtonText, for: .normal)

      collectionView.reloadData()
    }
  }

  @objc
  private func adjustForKeyboard(notification: Notification) {
    guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

    let keyboardScreenEndFrame = keyboardValue.cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: UIApplication.shared.asKeyWindow)

    if notification.name == UIResponder.keyboardWillHideNotification {
      collectionView.contentInset = .zero
    } else {
      collectionView.contentInset = .init(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
    }
  }

  @objc
  private func didTapClose(_: UIBarButtonItem) {
    dismiss(animated: true)
  }

  @objc
  private func didTapSaveButton(_ button: UIButton) {
    interactor?.didTapSaveButton()
  }
}

// MARK: EditProfileViewControllerProtocol

extension EditProfileViewController: EditProfileViewControllerProtocol {

  func setSaveButtonEnabled(_ flag: Bool) {
    flag ? saveButton.enable() : saveButton.disable()
  }

  func updateUI(viewModel: EditProfileViewModel) {
    self.viewModel = viewModel
  }
}

// MARK: UICollectionViewDataSource

extension EditProfileViewController: UICollectionViewDataSource {
  func numberOfSections(in _: UICollectionView) -> Int {
    viewModel?.sections.count ?? 0
  }

  func collectionView(
    _: UICollectionView,
    numberOfItemsInSection section: Int)
    -> Int
  {
    switch viewModel?.sections[safe: section] {
    case .commonEditCell(let models):
      return models.count

    case .deleteAccount(let models):
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
        cell.decorate(model: text)
        cell.delegate = self
        return cell

      case .none:
        return .init()
      }

    case .deleteAccount(let models):
      if let model = models[safe: indexPath.row], let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LogOutCell.reuseId, for: indexPath) as? LogOutCell {
        cell.decorate(model: model)
        return cell
      }
      return .init()

    case .none:
      return .init()
    }
  }
}

// MARK: UICollectionViewDelegateFlowLayout

extension EditProfileViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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

    case .deleteAccount(let models):
      if models[safe: indexPath.row] != nil {
        return .init(width: collectionView.frame.width, height: LogOutCell.height())
      }
      return .zero

    case .none:
      return .zero
    }
  }

  func collectionView(
    _: UICollectionView,
    layout _: UICollectionViewLayout,
    minimumLineSpacingForSectionAt _: Int)
    -> CGFloat
  {
    0
  }

  func collectionView(
    _: UICollectionView,
    layout _: UICollectionViewLayout,
    insetForSectionAt _: Int)
    -> UIEdgeInsets
  {
    UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch viewModel?.sections[safe: indexPath.section] {
    case .commonEditCell:
      break

    case .deleteAccount:
      interactor?.didTapDeleteAccount()

    case .none:
      break
    }
  }
}

// MARK: CommonEditCollectionViewCellDelegate

extension EditProfileViewController: CommonEditCollectionViewCellDelegate {
  func didChangedText(_ textField: UITextField, recognizableIdentificator: String?) {
    if
      let recognizableIdentificator = recognizableIdentificator,
      let type = EditProfileTextFieldType(rawValue: recognizableIdentificator)
    {
      interactor?.textFieldDidChanged(type: type, newValue: textField.text)
    }
  }
}
