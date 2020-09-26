//
//  WriteMessageController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 18.06.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display
import Core
import Database
import RealmSwift
import VinchyCore
import StringFormatting

final class WriteMessageController: UIViewController {

    var note: Note?
    var wine: Wine?
    var subject: String?
    var body: String?

    private let dataBase = Database<Note>()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EnterMessageCell.self, forCellReuseIdentifier: EnterMessageCell.reuseId)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        tableView.estimatedRowHeight = 69
        tableView.separatorStyle = .none

        return tableView
    }()

    private lazy var bottomConstraint = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
    private let keyboardHelper = KeyboardHelper()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if let wine = wine {
            navigationItem.title = wine.title
        } else if let note = note {
            navigationItem.title = note.wineTitle
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomConstraint,
        ])

        configureKeyboardHelper()
    }

    private func configureKeyboardHelper() {
        keyboardHelper.bindBottomToKeyboardFrame(
            animated: true,
            animate: { [weak self] height in
                self?.bottomConstraint.constant = -height
                self?.view.layoutSubviews()
        })
    }

    @objc private func save() {

        guard let title = subject, !title.isEmpty else { return }

        if let note = note {
            try! realm(path: .notes).write {
                note.title = title
                note.fullReview = body ?? ""
            }
        }

        if let wine = wine {
            let note = Note(id: dataBase.incrementID(path: .notes), wineID: wine.id, wineTitle: wine.title, wineMainImageURL: wine.mainImageUrl ?? "", title: title, fullReview: body ?? "")
            dataBase.add(object: note, at: .notes)
        }
        
        navigationController?.popViewController(animated: true)
    }
}

extension WriteMessageController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: EnterMessageCell.reuseId) as? EnterMessageCell else {
            return UITableViewCell()
        }

        cell.tableView = tableView
        cell.delegate = self

        if indexPath.row == 0 {
            cell.labelPlaceholder.text = localized("general_impression").firstLetterUppercased()
            cell.textFieldTitle.text = localized("general_impression").firstLetterUppercased()
            if subject != nil {
                cell.textField.text = subject
                cell.cell(isSelected: true)
            }
        } else {
            cell.labelPlaceholder.text = localized("description").firstLetterUppercased()
            cell.textFieldTitle.text = localized("description").firstLetterUppercased()


            if body != nil {
                cell.textField.text = body
                cell.cell(isSelected: true)
            }

            cell.line.isHidden = true
        }
        cell.textViewDidChange(cell.textField)

        return cell
    }
}

extension WriteMessageController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? EnterMessageCell
        cell?.textField.becomeFirstResponder()
        tableView.beginUpdates()
        tableView.endUpdates()
    }

}

extension WriteMessageController: EnterMessageCellDelegate {
    func handleEditing(title: String, fullReview: String?) {
        subject = title
        body = fullReview
    }
}
