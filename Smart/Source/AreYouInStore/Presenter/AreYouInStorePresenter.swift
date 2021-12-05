//
//  AreYouInStorePresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 30.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display
import StringFormatting
import UIKit
import VinchyCore

// MARK: - AreYouInStorePresenter

final class AreYouInStorePresenter {

  // MARK: Lifecycle

  init(input: AreYouInStoreInput, viewController: AreYouInStoreViewControllerProtocol) {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: AreYouInStoreViewControllerProtocol?

  // MARK: Private

  private var input: AreYouInStoreInput

}

// MARK: AreYouInStorePresenterProtocol

extension AreYouInStorePresenter: AreYouInStorePresenterProtocol {
  func update() {

    let bottomButtonsViewModel = BottomButtonsViewModel(
      leadingButtonText: localized("AreYouInStore.NotHere"),
      trailingButtonText: localized("AreYouInStore.SeeMore"))

    let recommendedWines = input.partner.recommendedWines

    let storeTitle = input.partner.partner.title.quoted
    let fullStoreText = NSMutableAttributedString(string: localized("AreYouInStore.SeemsYouAreIn") + storeTitle, font: Font.bold(24), textColor: .dark)
    let range = ((localized("AreYouInStore.SeemsYouAreIn") + storeTitle) as NSString).range(of: storeTitle)
    fullStoreText.addAttribute(.foregroundColor, value: UIColor.accent, range: range)

    let viewModel = AreYouInStoreViewModel(
      sections: [
        .title([
          .init(titleText: fullStoreText),
        ]),

        .title([
          .init(titleText: NSAttributedString(string: localized("AreYouInStore.RecommendToBuy"), font: Font.heavy(20), textColor: .dark)),
        ]),

        .recommendedWines([
          .init(type: .bottles, collections: [.init(wineList: recommendedWines)]),
        ]),
      ],
      bottomButtonsViewModel: bottomButtonsViewModel)
    viewController?.updateUI(viewModel: viewModel)
  }
}
