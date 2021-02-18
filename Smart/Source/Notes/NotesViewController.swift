//
//  NotesViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 22.06.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import RealmSwift
import Core
import StringFormatting
import CommonUI
import Database
import Display

final class NotesViewController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating {
  
  // MARK: - Private Properties
  private let tableView = UITableView()
  private lazy var notesRealm = realm(path: .notes)
  private let dataBase = Database<Note>()
  private var notesNotificationToken: NotificationToken?
  private let throttler = Throttler()
  
  private var notes: [Note] = [] {
    didSet {
      notes.isEmpty ? showEmptyView() : hideEmptyView()
      tableView.reloadData()
    }
  }

  // MARK: - Lifecycle
  
  init() {
    super.init(nibName: nil, bundle: nil)
    notesNotificationToken = notesRealm.observe { _, _ in
      self.notes = self.dataBase.all(at: .notes)
    }
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
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
    
    notes = dataBase.all(at: .notes)
  }
  
  deinit {
    notesNotificationToken?.invalidate()
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    didEnterSearchText(searchController.searchBar.text)
  }
  
  private func didEnterSearchText(_ searchText: String?) {
    
    guard
      let searchText = searchText?.firstLetterUppercased(),
      !searchText.isEmpty
    else {
      throttler.cancel()
      self.notes = self.dataBase.all(at: .notes)
      return
    }
    
    throttler.cancel()
    
    throttler.throttle(delay: .milliseconds(600)) { [weak self] in
      let predicate = NSPredicate(format: "wineTitle CONTAINS %@ OR noteText CONTAINS %@", searchText, searchText)
      self?.notes = self?.dataBase.filter(
        at: .notes,
        predicate: predicate) ?? []
    }
  }
  // MARK: - Private Methods
  
  private func hideEmptyView() {
    tableView.backgroundView = nil
  }
  
  private func showEmptyView() {
    let errorView = ErrorView(frame: view.frame)
    errorView.decorate(model: .init(titleText: localized("nothing_here").firstLetterUppercased(),
                                    subtitleText: localized("you_have_not_written_any_notes_yet").firstLetterUppercased(),
                                    buttonText: nil))
    tableView.backgroundView = errorView
  }
}

// MARK: - UITableViewDataSource

extension NotesViewController: UITableViewDataSource {
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int)
    -> Int
  {
    notes.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
  {
    if let cell = tableView.dequeueReusableCell(withIdentifier: WineTableCell.reuseId) as? WineTableCell,
       let note = notes[safe: indexPath.row] {
      cell.decorate(model: .init(imageURL: imageURL(from: note.wineID).toURL, titleText: note.wineTitle, subtitleText: note.noteText))
      return cell
    }
    return .init()
  }
  
  func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath)
  {
    if editingStyle == .delete, let note = notes[safe: indexPath.row] {
      
      let alert = UIAlertController(title: localized("delete_note"),
                                    message: localized("this_action_cannot_to_be_undone"),
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: localized("delete"), style: .destructive, handler:{ [weak self] _ in
        guard let self = self else { return }
        self.dataBase.remove(object: note, at: .notes)
        self.notes = self.dataBase.all(at: .notes)
      }))
      alert.addAction(UIAlertAction(title: localized("cancel"), style: .cancel, handler: nil))
      present(alert, animated: true, completion: nil)
      self.tableView.reloadData()
    }
  }
  
  func tableView(
    _ tableView: UITableView,
    titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath)
    -> String?
  {
    localized("delete")
  }
}

// MARK: - UITableViewDelegate

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
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    if !navigationItem.hidesSearchBarWhenScrolling {
      navigationItem.hidesSearchBarWhenScrolling = true
    }
  }
}
