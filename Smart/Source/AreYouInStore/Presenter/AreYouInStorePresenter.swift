//
//  AreYouInStorePresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 30.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display
import VinchyCore

// MARK: - AreYouInStorePresenter

final class AreYouInStorePresenter {

  // MARK: Lifecycle

  init(viewController: AreYouInStoreViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: AreYouInStoreViewControllerProtocol?

}

// MARK: AreYouInStorePresenterProtocol

extension AreYouInStorePresenter: AreYouInStorePresenterProtocol {
  func update(title: String?) {

    let bottomButtonsViewModel = BottomButtonsViewModel(
      leadingButtonText: "Я не здесь",
      trailingButtonText: "Смотреть ещё")

    let viewModel = AreYouInStoreViewModel(
      sections: [
        .title([
          .init(titleText: NSAttributedString(string: title ?? "", font: Font.bold(24), textColor: .dark, paragraphAlignment: .center)),
        ]),

//        .title([
//          .init(titleText: NSAttributedString(string: "Рекомендуем обратить внимание", font: Font.regular(16), textColor: .dark)),
//        ]),

        .recommendedWines([
          .init(type: .bottles, collections: [.init(wineList: [.wine(wine: ShortWine.fake)])]),
        ]),
      ],
      bottomButtonsViewModel: bottomButtonsViewModel)
    viewController?.updateUI(viewModel: viewModel)
  }
}
