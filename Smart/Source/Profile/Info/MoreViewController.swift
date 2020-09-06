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

protocol MoreViewProtocol: AnyObject {
    func presentAlert(message: String)
}

final class MoreViewController: UIViewController, Alertable {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .mainBackground //UIColor.rgb(red: 247, green: 248, blue: 250, alpha: 1)

        return tableView
    }()
    
    private lazy var cells = [
        ContactCell(icon: UIImage(named: "phone")!,
                    text: localized("contact_phone"),
                    detailText: localized("for_any_questions").firstLetterUppercased()),

        ContactCell(icon: UIImage(systemName: "envelope.fill")!,
                    text: localized("contact_email"),
                    detailText: localized("email_us").firstLetterUppercased()),

        ContactCell(icon: UIImage(named: "job")!,
                    text: localized("looking_for_partners").firstLetterUppercased(),
                    detailText: localized("become_a_part_of_a_wine_startup").firstLetterUppercased()),

        SocialMediaCell(delegate: self),

        RateAppCell(),

        DocCell(icon: UIImage(named: "document")!,
                text: localized("legal_documents").firstLetterUppercased()),

        DocCell(icon: UIImage(named: "info")!.withRenderingMode(.alwaysTemplate),
                text: localized("about_the_app").firstLetterUppercased())
    ]

    var presenter: MorePresenterProtocol!
    private let configurator = MoreConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        title = localized("info").firstLetterUppercased()
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension MoreViewController: SocialMediaCellDelegate {
    func didClickVK() {
        presenter.openVk()
    }
    
    func didClickInstagram() {
        presenter.openInstagram()
    }
}

extension MoreViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[safe: indexPath.row] ?? .init()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = TableViewHeader()
        header.decorate(model: .init(titleText: localized("always_available").firstLetterUppercased()))
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            presenter.callUs()
        case 1:
            presenter.emailUs()
        case 2:
            presenter.workWithUs()
        case 4:
            presenter.rateApp()
        case 5:
            presenter.goToDocController()
        case 6:
            presenter.goToAboutController()
        default:
            break
        }
    }
}

extension MoreViewController: MoreViewProtocol {
    func presentAlert(message: String) {
        showAlert(message: message)
    }
}
