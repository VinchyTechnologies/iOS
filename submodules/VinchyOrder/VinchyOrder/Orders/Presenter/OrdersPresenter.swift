//
//  OrdersPresenter.swift
//  VinchyOrder
//
//  Created by Алексей Смирнов on 20.02.2022.
//

import StringFormatting
import VinchyCore

// MARK: - OrdersPresenter

final class OrdersPresenter {

  // MARK: Lifecycle

  init(viewController: OrdersViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: OrdersViewControllerProtocol?

}

// MARK: OrdersPresenterProtocol

extension OrdersPresenter: OrdersPresenterProtocol {

  func startLoading() {
    viewController?.startLoadingAnimation()
    viewController?.addLoader()
  }

  func stopLoading() {
    viewController?.stopLoadingAnimation()
  }

  func update(orders: [Order], needLoadMore: Bool) {
    let viewModel = OrdersViewModel(
      state: .normal(sections: [
        .content(dataID: .content, items: [
          .order(content: .init(orderID: 1, dateText: "29.08.2021", orderNumberText: "Заказ #1", priceText: "25000p", statusText: "Выдан", statusColor: .systemGreen)),
          .order(content: .init(orderID: 2, dateText: "29.08.2021", orderNumberText: "Заказ #2", priceText: "115000p", statusText: "В работе", statusColor: .systemOrange)),
          .order(content: .init(orderID: 3, dateText: "29.08.2021", orderNumberText: "Заказ #3", priceText: "800р", statusText: "Отменен", statusColor: .systemRed)),
        ]),
      ]),
      navigationTitle: "Orders")
    viewController?.updateUI(viewModel: viewModel)
  }

  func showErrorAlert(error: Error) {
    viewController?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: error.localizedDescription)
  }

  func showNothingFoundErrorView() {
    viewController?.updateUI(viewModel: .init(state: .error(sections: [.common(content: .init(titleText: localized("nothing_found").firstLetterUppercased(), subtitleText: nil, buttonText: nil))]), navigationTitle: "Orders"))
  }

  func showInitiallyLoadingError(error: Error) {
    viewController?.updateUI(
      viewModel: .init(
        state: .error(
          sections: [
            .common(
              content: .init(
                titleText: localized("error").firstLetterUppercased(),
                subtitleText: error.localizedDescription,
                buttonText: localized("reload").firstLetterUppercased())),
          ]),
        navigationTitle: "Orders"))
  }
}
