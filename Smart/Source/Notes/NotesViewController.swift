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

final class NotesViewController: UIViewController {

    private let tableView = UITableView()
    private lazy var notesRealm = realm(path: .notes)
    let dataBase = Database<Note>()
    private var notesNotificationToken: NotificationToken?

    private var notes: [Note] = [] {
        didSet {

            if notes.isEmpty {
                showEmptyView()
            } else {
                hideEmptyView()
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)

        notesNotificationToken = notesRealm.observe { notification, realm in
            self.notes = self.dataBase.all(at: .notes)
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = localized("notes").firstLetterUppercased()

        view.addSubview(tableView)
        tableView.frame = view.frame
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

    private func hideEmptyView() {
        tableView.backgroundView = nil
    }

    private func showEmptyView() {
        let errorView = ErrorView(frame: view.frame)
        errorView.isButtonHidden = true
        // TODO - localized
        errorView.configure(title: "Пока пусто", description: "Нет сохраненных адресов", buttonText: "Добавить")
        tableView.backgroundView = errorView
    }

}

extension NotesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: WineTableCell.reuseId) as? WineTableCell,
            let note = notes[safe: indexPath.row] {
            cell.decorate(model: .init(imageURL: note.wineMainImageURL, title: note.wineTitle, subtitle: note.title))
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let note = notes[safe: indexPath.row] {

            let alert = UIAlertController(title: localized("delete_note"),
                                          message: localized("this_action_cannot_to_be_undone"),
                                          preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: localized("delete"), style: .destructive , handler:{ [weak self] _ in
                guard let self = self else { return }
                self.dataBase.remove(object: note, at: .notes)
                self.notes = self.dataBase.all(at: .notes)
            }))

            alert.addAction(UIAlertAction(title: localized("cancel"), style: .cancel, handler: nil))

            present(alert, animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        localized("delete")
    }
}

extension NotesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let note = notes[safe: indexPath.row] else { return }
        let writeMessageController = WriteMessageController()
        writeMessageController.hidesBottomBarWhenPushed = true
        writeMessageController.note = note
        writeMessageController.subject = note.title
        writeMessageController.body = note.fullReview
        navigationController?.pushViewController(writeMessageController, animated: true)
    }
}
