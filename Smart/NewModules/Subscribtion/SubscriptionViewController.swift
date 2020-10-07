//
//  SubscriptionViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 24.06.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

final class SubscriptionViewController: UIViewController {

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        let closeBarButtonItem = UIBarButtonItem(image: UIImage(named: "x"), style: .plain, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = closeBarButtonItem

        navigationItem.title = "Subscriptions"

        tableView.backgroundColor = .mainBackground
        view.backgroundColor = .mainBackground
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.separatorInset = .zero
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(SubscriptionTableCell.self, forCellReuseIdentifier: SubscriptionTableCell.reuseId)
    }

    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }

}

extension SubscriptionViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SubscriptionTableCell.reuseId) as? SubscriptionTableCell {
            cell.decorate(model: .init(imageName: "noad", title: "No Ads", price: "2.99 $"))
            return cell
        }
        return UITableViewCell()
    }

}

extension SubscriptionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

struct SubscriptionTableCellViewModel: ViewModelProtocol {
    let imageName: String
    let title: String
    let price: String
}

final class SubscriptionTableCell: UITableViewCell, Reusable {

    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.bold(24)
        label.numberOfLines = 2

        return label
    }()

    let priceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .mainBackground
        button.setTitleColor(.dark, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        button.titleLabel?.font = Font.bold(18)

        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        addSubview(priceButton)
        NSLayoutConstraint.activate([
            priceButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            priceButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: priceButton.leadingAnchor, constant: -10),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        priceButton.layer.cornerRadius = priceButton.frame.height / 2
    }
}

extension SubscriptionTableCell: Decoratable {

    typealias ViewModel = SubscriptionTableCellViewModel

    func decorate(model: ViewModel) {
        titleLabel.text = model.title
        iconImageView.image = UIImage(named: model.imageName)
        priceButton.setTitle(model.price, for: .normal)
    }

}
