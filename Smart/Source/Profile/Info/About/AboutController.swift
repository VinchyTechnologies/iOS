//
//  AboutController.swift
//  Coffee
//
//  Created by Алексей Смирнов on 12/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//
// swiftlint:disable all

import UIKit
import Display
import StringFormatting
import Core

final class AboutController: UIViewController, OpenURLProtocol, Alertable {
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String
        label.font = Font.bold(45)
        return label
    }()
    
    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = localized("version") + " " + String(describing: Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)
        label.font = Font.regular(18)
        label.textColor = .dark
        return label
    }()
    
    lazy var webButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(instagramURL, for: .normal)
        button.setTitleColor(.accent, for: .normal)
        button.titleLabel?.font = Font.bold(15)
        button.addTarget(self, action: #selector(actionOpenWebSite), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = localized("about_the_app").firstLetterUppercased()

        view.addSubview(logoLabel)
        NSLayoutConstraint.activate([
            logoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        view.addSubview(versionLabel)
        NSLayoutConstraint.activate([
            versionLabel.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 20),
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        view.addSubview(webButton)
        NSLayoutConstraint.activate([
            webButton.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 15),
            webButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    @objc private func actionOpenWebSite() {
        open(urlString: instagramURL) {
            showAlert(message: localized("open_url_error"))
        }
    }
}
