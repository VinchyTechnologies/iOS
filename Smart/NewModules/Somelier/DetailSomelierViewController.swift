//
//  DetailSomelierViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 08.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import AsyncDisplayKit // l

class DetailSomelierViewController: ASDKViewController<SomelierNode> {

    override init() {
        let node = SomelierNode()
        super.init(node: node)

        navigationItem.title = "Hi, there!"

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(didTapNotes))

        node.delegate = self

        let arg1 = ["https://www.westernunion.com/content/dam/wu/jm/responsive/send-money-in-person-from-jamaica-resp.png"]
        let imageURLs = arg1

        node.decorate(model: .init(imageURLs: imageURLs,
                                   title: "Maria Gosh",
                                   description: "product.desc",
                                   isFavourite: true,
                                   isDisliked: true,
                                   price: "123",
                                   options: [
                                    DetailOption(title: "7-8 лет", subtitle: "Возраст"),
                                    DetailOption(title: "Pinout Nuaur", subtitle: "Виноград"),
                                    DetailOption(title: "France", subtitle: "Region")

        ]))
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        view.backgroundColor = .mainBackground
    }

    @objc private func didTapNotes() {

    }
}

extension DetailSomelierViewController: SomelierNodeDelegate {

    func didTapDislikeNode() {

    }

    func didTapLikeNode() {

    }

    func didTapShareNode() {

    }

    func didTapPriceNode() {

    }


    func didTapReportError() {

    }

}
