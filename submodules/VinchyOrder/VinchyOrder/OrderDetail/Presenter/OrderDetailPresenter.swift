//
//  OrderDetailPresenter.swift
//  VinchyOrder
//
//  Created by Алексей Смирнов on 21.02.2022.
//

import Foundation

// MARK: - OrderDetailPresenter

final class OrderDetailPresenter {

  // MARK: Lifecycle

  init(viewController: OrderDetailViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: OrderDetailViewControllerProtocol?

}

// MARK: OrderDetailPresenterProtocol

extension OrderDetailPresenter: OrderDetailPresenterProtocol {
  func update() {
    var sections: [OrderDetailViewModel.Section] = []

    sections.append(.orderNumber(.init(dateText: "29.08.2021 14:35", statusText: "Выдан", statusColor: .systemGreen)))

    sections.append(.logo(.init(title: "Перекресток", logoURL: "https://s3.eu-central-1.amazonaws.com/bucket.vinchy.tech/partners_logos/Perekrestok.png")))

    sections.append(.address(.init(titleText: "Красная площадь, 7А", isMapButtonHidden: true)))

    sections.append(.orderItem(.init(imageURL: "https://bucket.vinchy.tech/wines/2910.png".toURL, titleText: "Dom Perignon Dom Perignon Dom Perignon Dom Perignon", subtitleText: "France", leadingPriceText: "12 x 15000p", trailingPriceText: "1000000p")))

    sections.append(.title(content: "Итого 1505 Р"))

    let viewModel = OrderDetailViewModel(sections: sections, navigationTitleText: "Заказ #213", bottomBarViewModel: .init(leadingText: nil, trailingButtonText: "Повторить заказ"))
    viewController?.updateUI(viewModel: viewModel)
  }
}
