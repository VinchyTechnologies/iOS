//
//  NotesViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 22.06.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Core
import Database
import Display
import StringFormatting
import UIKit

// MARK: - NotesViewController

final class NotesViewController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating {

  // MARK: Internal

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = localized("notes").firstLetterUppercased()
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationController?.navigationBar.sizeToFit()

    view.addSubview(tableView)
    tableView.fill()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.tableFooterView = UIView()
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    tableView.register(WineTableCell.self, forCellReuseIdentifier: WineTableCell.reuseId)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    notes = notesRepository.findAll()
  }

  // MARK: - Internaal Methods

  func updateSearchResults(for searchController: UISearchController) {
    didEnterSearchText(searchController.searchBar.text)
  }

  // MARK: Private

  // MARK: - Private Properties

  private let tableView = UITableView()
  private let throttler = Throttler()

  private lazy var searchController: UISearchController = {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.autocapitalizationType = .none
    searchController.searchBar.searchTextField.font = Font.medium(20)
    searchController.searchBar.searchTextField.layer.cornerRadius = 20
    searchController.searchBar.searchTextField.layer.masksToBounds = true
    searchController.searchBar.searchTextField.layer.cornerCurve = .continuous
    searchController.delegate = self
    searchController.searchResultsUpdater = self
    searchController.hidesNavigationBarDuringPresentation = true
    return searchController
  }()

  private var notes: [VNote] = [] {
    didSet {
      updateUI()
    }
  }

  // MARK: - Private Methods

  private func didEnterSearchText(_ searchText: String?) {
    guard
      let searchText = searchText?.firstLetterUppercased(),
      !searchText.isEmpty
    else {
      throttler.cancel()
      notes = notesRepository.findAll()
      return
    }

    throttler.cancel()

    throttler.throttle(delay: .milliseconds(600)) { [weak self] in
      let predicate = NSPredicate(format: "wineTitle CONTAINS %@ OR noteText CONTAINS %@", searchText, searchText)
      var searchedNotes = [VNote]()
      self?.notes.forEach { note in
        if predicate.evaluate(with: note) {
          searchedNotes.append(note)
        }
      }
      self?.notes = searchedNotes
    }
  }

  private func hideEmptyView() {
    tableView.backgroundView = nil
  }

  private func showEmptyView(title: String, subtitle: String) {
    let errorView = ErrorView(frame: view.frame)
    errorView.decorate(model: .init(
      titleText: title.firstLetterUppercased(),
      subtitleText: subtitle.firstLetterUppercased(),
      buttonText: nil))
    tableView.backgroundView = errorView
  }

  private func updateUI() {
    if searchController.searchBar.text?.isEmpty == true {
      notes.isEmpty ? showEmptyView(title: localized("nothing_here"), subtitle: localized("you_have_not_written_any_notes_yet")) : hideEmptyView()
    } else {
      notes.isEmpty ? showEmptyView(title: localized("nothing_here"), subtitle: localized("no_notes_found_for_your_request")) : hideEmptyView()
    }
    tableView.reloadData()
  }
}

// MARK: UITableViewDataSource

extension NotesViewController: UITableViewDataSource {
  func tableView(
    _: UITableView,
    numberOfRowsInSection _: Int)
    -> Int
  {
    notes.count
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
  {
    if
      let cell = tableView.dequeueReusableCell(withIdentifier: WineTableCell.reuseId) as? WineTableCell,
      let note = notes[safe: indexPath.row],
      let wineID = note.wineID,
      let wineTitle = note.wineTitle,
      let noteText = note.noteText
    {
      cell.decorate(model: .init(imageURL: imageURL(from: wineID).toURL, titleText: wineTitle, subtitleText: noteText))
      return cell
    }
    return .init()
  }

  func tableView(
    _: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath)
  {
    if editingStyle == .delete, let note = notes[safe: indexPath.row] {
      let alert = UIAlertController(
        title: localized("delete_note"),
        message: localized("this_action_cannot_to_be_undone"),
        preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: localized("delete"), style: .destructive, handler: { [weak self] _ in
        guard let self = self else { return }
        notesRepository.remove(note)
        self.notes = notesRepository.findAll()
      }))
      alert.addAction(UIAlertAction(title: localized("cancel"), style: .cancel, handler: nil))
      present(alert, animated: true, completion: nil)
      tableView.reloadData()
    }
  }

  func tableView(
    _: UITableView,
    titleForDeleteConfirmationButtonForRowAt _: IndexPath)
    -> String?
  {
    localized("delete")
  }
}

// MARK: UITableViewDelegate

extension NotesViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath)
  {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let note = notes[safe: indexPath.row] else { return }
    let controller = Assembly.buildWriteNoteViewController(for: note)
    navigationController?.pushViewController(controller, animated: true)
  }

  func scrollViewWillBeginDragging(_: UIScrollView) {
    if !navigationItem.hidesSearchBarWhenScrolling {
      navigationItem.hidesSearchBarWhenScrolling = true
    }
  }
}
