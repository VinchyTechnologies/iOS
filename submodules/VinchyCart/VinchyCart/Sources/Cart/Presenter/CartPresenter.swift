//
//  CartPresenter.swift
//  VinchyCart
//
//  Created by Алексей Смирнов on 11.02.2022.
//

import Foundation

// MARK: - CartPresenter

final class CartPresenter {

  // MARK: Lifecycle

  init(viewController: CartViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: CartViewControllerProtocol?

}

// MARK: CartPresenterProtocol

extension CartPresenter: CartPresenterProtocol {
  func update() {
    var sections: [CartViewModel.Section] = []

    sections.append(.logo(.init(title: "Перекресток", logoURL: "https://s3.eu-central-1.amazonaws.com/bucket.vinchy.tech/partners_logos/Perekrestok.png")))

    sections.append(.address(.init(titleText: "Красная площадь, 7А", isMapButtonHidden: true)))

    sections.append(.cartItem(.init(wineID: 100, imageURL: "https://bucket.vinchy.tech/wines/2910.png".toURL, titleText: "Dom Perignon Dom Perignon Dom Perignon Dom Perignon", subtitleText: "France", priceText: "123P", value: 1)))
    sections.append(.title(content: "Итого 1505 Р"))

    let viewModel = CartViewModel(sections: sections, navigationTitleText: "Корзина", bottomBarViewModel: .init(leadingText: nil, trailingButtonText: "Оформить заказ"))
    viewController?.updateUI(viewModel: viewModel)
  }
}
