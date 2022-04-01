//
//  EditProfileViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 15.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import EpoxyCollectionView
import UIKit

// MARK: - EditProfileViewController

final class EditProfileViewController: CollectionViewController {

  // MARK: Lifecycle

  init() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 0
    super.init(layout: layout)
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

  override func makeCollectionView() -> CollectionView {
    let collectionView = super.makeCollectionView()
    collectionView.keyboardDismissMode = .onDrag
    collectionView.backgroundColor = .mainBackground
    return collectionView
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    if UIApplication.shared.applicationState != .background {
      coordinator.animate(alongsideTransition: { _ in
        self.collectionViewSize = size
        self.setSections(self.sections, animated: false)
      })
    }
  }

  // MARK: Private

  private lazy var collectionViewSize: CGSize = view.frame.size

  private lazy var saveButton: Button = {
    $0.disable()
    $0.addTarget(self, action: #selector(didTapSaveButton(_:)), for: .touchUpInside)
    return $0
  }(Button())

  private var viewModel: EditProfileViewModel = .empty

  @SectionModelBuilder
  private var sections: [SectionModel] {
    viewModel.sections.compactMap { section in
      switch section {
      case .commonEditCell(let rows):
        return SectionModel.init(dataID: UUID()) {
          return rows.compactMap { row in
            switch row {
            case .title(let content):
              let width: CGFloat = collectionViewSize.width - 48
              let style = Label.Style.style(with: .miniBold)
              let height: CGFloat = Label.height(
                for: content,
                width: width,
                style: style)
              return Label.itemModel(
                dataID: UUID(),
                content: content,
                style: style)
                .flowLayoutItemSize(.init(width: width, height: height))

            case .textField(let content):
              let width = collectionViewSize.width - 48
              return CommonEditView.itemModel(dataID: UUID(), content: content, style: .init())
                .setBehaviors({ [weak self] context in
                  context.view.delegate = self
                })
                .flowLayoutItemSize(.init(width: width, height: CommonEditView.height(for: content)))
            }
          }
        }
        .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 0, right: 24))
      }
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
    navigationItem.title = viewModel.navigationTitle
    saveButton.setTitle(viewModel.saveButtonText, for: .normal)
    collectionView.setSections(sections, animated: true)
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
