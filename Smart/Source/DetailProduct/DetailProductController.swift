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
import Database

final class DetailProductController: ASDKViewController<DetailProductNode>, Alertable {

    private var wine: Wine? {
        didSet {
            guard let wine = wine else { return }
            decorate(wine: wine)
        }
    }

    private let emailService = EmailService()
    private let dataBase = Database<DBWine>()

    init(wineID: Int64) {
        let node = DetailProductNode()
        super.init(node: node)
        loadWineInfo(wineID: wineID)

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(didTapNotes))

        node.delegate = self
        node.view.delegate = self

        node.view.setContentOffset(.zero, animated: true)
        edgesForExtendedLayout = []
    }

    required init?(coder: NSCoder) { fatalError() }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .mainBackground
    }

    @objc private func didTapNotes() {

        guard let wine = wine else { return }
        let controller = WriteMessageController()
        
        if let note = realm(path: .notes).objects(Note.self).first(where: { $0.wineID == wine.id }) {
            controller.note = note
            controller.subject = note.title
            controller.body = note.fullReview
        } else {
            controller.wine = wine
        }

        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }

    private func loadWineInfo(wineID: Int64) {
        Wines.shared.getDetailWine(wineID: wineID) { [weak self] result in
            switch result {
            case .success(let wine):
                self?.wine = wine
            case .failure(let error):
                self?.showAlert(message: error.localizedDescription)
            }
        }
    }

    private func decorate(wine: Wine) {
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
            return .init(title: dish.rawValue, imageName: DishCompatibility(rawValue: dish.rawValue)?.imageName)
        }

        let isFavourite = realm(path: .like).objects(DBWine.self).first(where: { $0.wineID == wine.id }) != nil
        let isDisliked = realm(path: .dislike).objects(DBWine.self).first(where: { $0.wineID == wine.id }) != nil

        node.decorate(model: .init(imageURLs: imageURLs.compactMap({ $0 }),
                                   title: wine.title,
                                   description: wine.desc,
                                   isFavourite: isFavourite,
                                   isDisliked: isDisliked,
                                   price: formatCurrencyAmount(wine.price, currency: "USD"), // TODO: - Price
            options:options,
            dishCompatibility: dishCompatibility, place: wine.place))
    }
}

extension DetailProductController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 300 {
            self.navigationItem.title = self.wine?.title
        } else {
            self.navigationItem.title = nil
        }
    }
}

extension DetailProductController: DetailProductNodeDelegate {

    func didTapDislikeNode() {
        guard let wine = wine else { return }
        if let dbWine = realm(path: .dislike).objects(DBWine.self).first(where: { $0.wineID == wine.id }) {
            dataBase.remove(object: dbWine, at: .dislike)
        } else {
            dataBase.add(object: DBWine(id: dataBase.incrementID(path: .dislike), wineID: wine.id, mainImageUrl: wine.mainImageUrl, title: wine.title), at: .dislike)
        }
    }

    func didTapLikeNode() {
        guard let wine = wine else { return }
        if let dbWine = realm(path: .like).objects(DBWine.self).first(where: { $0.wineID == wine.id }) {
            dataBase.remove(object: dbWine, at: .like)
        } else {
            dataBase.add(object: DBWine(id: dataBase.incrementID(path: .like), wineID: wine.id, mainImageUrl: wine.mainImageUrl, title: wine.title), at: .like)
        }
    }

    func didTapShareNode() {
        guard let wine = wine else { return }
        let items = [wine.title]
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(controller, animated: true)
    }

    func didTapPriceNode() { }

    func didTapReportError() {
        guard let wine = wine else { return }
        if emailService.canSend {
            let vc = emailService.getEmailController(HTMLText: wine.title, recipients: [localized("contact_email")])
            navigationController?.present(vc, animated: true, completion: nil)
        } else {
            showAlert(message: "Возникла ошибка при открытии почты") // TODO: - Localize
        }
    }

}
