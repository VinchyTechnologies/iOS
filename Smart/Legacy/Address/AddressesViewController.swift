//
//  AddressesViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 10.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import RealmSwift
import CommonUI

//final class AddressesViewController: UIViewController, RealmProductProtocol {
//
//    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
//    private var notificationToken: NotificationToken?
//    private let realm: Realm = {
//        var config = Realm.Configuration()
//        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\("username").realm") // TODO: - userNameOrID
//        let realm = try! Realm(configuration: config)
//        return realm
//    }()
//
//    var addresses: [Address] = [] {
//        didSet {
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
//
//    override func loadView() {
//        super.loadView()
//        view.backgroundColor = .white
//
//        navigationItem.title = "Адреса"
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToMap))
//        navigationItem.rightBarButtonItems = [editButtonItem, addButton]
//
//        view.addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        self.addresses = self.allAddresses()
//        if addresses.isEmpty {
//            showEmptyView()
//        }
//
//        notificationToken = realm.observe { notification, realm in
//            if !self.hasAddress() {
//                self.showEmptyView()
//                return
//            }
//            self.hideEmptyView()
//            self.addresses = self.allAddresses()
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
//
//    deinit {
//        notificationToken?.invalidate()
//    }
//
//    private func hideEmptyView() {
//        tableView.backgroundView = nil
//    }
//
//    private func showEmptyView() {
//        let errorView = ErrorView(frame: self.view.frame)
//        errorView.delegate = self
//        errorView.configure(title: "Пока пусто", description: "Нет сохраненных адресов", buttonText: "Добавить")
//        self.tableView.backgroundView = errorView
//    }
//
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: true)
//        tableView.setEditing(editing, animated: true)
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            deleteAddress(address: addresses[indexPath.row])
//            self.addresses = allAddresses()
//        }
//    }
//
//    @objc private func goToMap() {
//        let mapViewController = MapViewController()
//        mapViewController.addressesViewController = self
//        navigationController?.pushViewController(mapViewController, animated: true)
//    }
//
//
//}
//
//extension AddressesViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        addresses.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        cell.selectionStyle = .none
//        cell.textLabel?.text = addresses[safe: indexPath.row]?.fullName
//        return cell
//    }
//
//}
//
//extension AddressesViewController: UITableViewDelegate {
//
//}
//
//extension AddressesViewController: ErrorViewDelegate {
//    func didTapErrorButton(_ button: UIButton) {
//        goToMap()
//    }
//}
