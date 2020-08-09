//
//  DetailProductController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 17.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AsyncDisplayKit
import Core
import EmailService
import StringFormatting
import Display

final class DetailProductController: ASDKViewController<DetailProductNode>, RealmLikeDislikeProtocol, RealmNotes, Alertable {

    // MARK: - Private Properties

    private let wine: Wine
    private let emailService = EmailService()

    // MARK: - Initializers

    init(wine: Wine) {
        let node = DetailProductNode()
        self.wine = wine
        super.init(node: node)

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(didTapNotes))

        node.delegate = self
        node.view.delegate = self

        let arg1 = [String(wine.mainImageUrl)]
        let arg2 = [String(wine.labelImageUrl)]
        let imageURLs = (arg1 + arg2 + Array(wine.imageURLs)).map { (str) -> String? in
            str == "" ? nil : str
        }

        var options = [DetailOption]()

        if wine.year != 0 {
            options.append(DetailOption(title: String(wine.year), subtitle: "Год"))
        }

        // TODO: - виноград

        if let country = wine.place.country, !country.isEmpty {
            options.append(DetailOption(title: country.firstLetterUppercased(), subtitle: "Country"))
        }

        let dishCompatibility = Array(wine.dishCompatibility).map { (dish) -> CaruselFilterNodeViewModel.CaruselFilterItem in
            return .init(title: dish, imageName: DishCompatibility(rawValue: dish)?.imageName)
        }


        node.decorate(model: .init(imageURLs: imageURLs.compactMap({ $0 }),
                                   title: wine.title,
                                   description: wine.desc,
                                   isFavourite: isLiked(product: wine),
                                   isDisliked: isDisliked(product: wine),
                                   price: wine.price.toPrice(), // TODO: - Price
            options:options,
            dishCompatibility: dishCompatibility, place: wine.place))

        node.view.setContentOffset(.zero, animated: true)
        edgesForExtendedLayout = []
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        view.backgroundColor = .mainBackground
    }

    @objc private func didTapNotes() {
        let controller = WriteMessageController()
        controller.product = wine
        let note = realm(path: .notes).object(ofType: Note.self, forPrimaryKey: wine.id)
        controller.subject = note?.title
        controller.body = note?.fullReview
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension DetailProductController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 300 {
            self.navigationItem.title = self.wine.title
        } else {
            self.navigationItem.title = nil
        }
    }
}

extension DetailProductController: DetailProductNodeDelegate {

    func didTapDislikeNode() {
        toOrUnDislike(product: wine)
    }

    func didTapLikeNode() {
        toOrUnLike(product: wine)
    }

    func didTapShareNode() {
        let items = [wine.title]
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(controller, animated: true)
    }

    func didTapPriceNode() {
//        dismiss(animated: true) {
//            self.saveToCart(product: self.product)
//        }
    }


    func didTapReportError() {
        if emailService.canSend {
            let vc = emailService.getEmailController(HTMLText: wine.title,
                                                     recipients: [localized("contact_email")])
            navigationController?.present(vc, animated: true, completion: nil)
        } else {
            showAlert(message: "Возникла ошибка при открытии почты") // TODO: - Localize
        }
    }

}
