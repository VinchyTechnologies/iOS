//
//  WriteNoteInteractor.swift
//  Smart
//
//  Created by Aleksei Smirnov on 30.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Database
import UIKit.UIBarButtonItem

// MARK: - WriteNoteInteractor

final class WriteNoteInteractor {

  // MARK: Lifecycle

  init(
    input: WriteNoteInput,
    router: WriteNoteRouterProtocol,
    presenter: WriteNotePresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let input: WriteNoteInput
  private let router: WriteNoteRouterProtocol
  private let presenter: WriteNotePresenterProtocol
  private var noteText: String?
}

// MARK: WriteNoteInteractorProtocol

extension WriteNoteInteractor: WriteNoteInteractorProtocol {

  func didTapDeleteNote(note: VNote) {
    notesRepository.remove(note)
    router.dismiss()
  }

  func didTapSaveOnAlert(text: String?) {
    noteText = text
    didTapSave()
  }

  func didTapClose(text: String?, barButtonItem: UIBarButtonItem?) {
    switch input.wine {
    case .database(let note):
      if note.noteText == text {
        router.dismiss()
      } else if text.isNilOrEmpty {
        router.showAlertToDelete(
          note: note,
          titleText: presenter.deleteTitleText,
          subtitleText: presenter.subtitleDeleteText,
          okText: presenter.deleteConfirmText,
          cancelText: presenter.cancelText,
          barButtonItem: barButtonItem)
      } else {
        router.showAlertYouDidntSaveNote(
          text: text,
          titleText: presenter.areYouSureToSaveTitleText,
          subtitleText: nil,
          okText: presenter.saveText,
          cancelText: presenter.cancelText,
          barButtonItem: barButtonItem)
      }

    case .firstTime:
      if text.isNilOrEmpty {
        router.dismiss()
      } else {
        router.showAlertYouDidntSaveNote(
          text: text,
          titleText: presenter.areYouSureToSaveTitleText,
          subtitleText: nil,
          okText: presenter.saveText,
          cancelText: presenter.cancelText,
          barButtonItem: barButtonItem)
      }
    }
  }

  func viewDidLoad() {
    switch input.wine {
    case .database(let note):
      presenter.setInitialNoteInfo(note: note)

    case .firstTime(let wine):
      presenter.setInitialNoteInfo(wine: wine)
    }
  }

  func didTapSave() {
    switch input.wine {
    case .database(let note):
      if noteText.isNilOrEmpty {
        router.showAlertToDelete(
          note: note,
          titleText: presenter.deleteTitleText,
          subtitleText: presenter.subtitleDeleteText,
          okText: presenter.deleteConfirmText,
          cancelText: presenter.cancelText,
          barButtonItem: nil)
        return
      } else {
        notesRepository.remove(note)
        let maxId = notesRepository.findAll().map { $0.id }.max() ?? 0
        let id = maxId + 1
        notesRepository.append(VNote(id: id, wineID: note.wineID, wineTitle: note.wineTitle, noteText: noteText ?? ""))
      }

    case .firstTime(let wine):
      guard let noteText = noteText, !noteText.isEmpty else {
        return
      }

      let maxId = notesRepository.findAll().map { $0.id }.max() ?? 0
      let id = maxId + 1
      notesRepository.append(VNote(id: id, wineID: wine.id, wineTitle: wine.title, noteText: noteText))
    }

    router.dismiss()
  }

  func didChangeNoteText(_ text: String?) {
    noteText = text

    switch input.wine {
    case .database(let note):
      if note.noteText == noteText {
        presenter.setSaveButtonActive(false)
      } else {
        presenter.setSaveButtonActive(true)
      }

    case .firstTime:
      if let text = text, !text.isEmpty {
        presenter.setSaveButtonActive(true)
      } else {
        presenter.setSaveButtonActive(false)
      }
    }
  }

  func didStartWriteText() {
    presenter.setPlaceholder()
  }
}
