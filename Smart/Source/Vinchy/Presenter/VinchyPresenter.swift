//
//  VinchyPresenter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import StringFormatting
import UIKit
import VinchyCore

// MARK: - VinchyPresenter

final class VinchyPresenter {

  // MARK: Lifecycle

  init(viewController: VinchyViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: VinchyViewControllerProtocol?

  // MARK: Private

  private enum C {
    static let harmfulToYourHealthText = localized("harmful_to_your_health")
  }
}

// MARK: VinchyPresenterProtocol

extension VinchyPresenter: VinchyPresenterProtocol {
  var cantFindWineText: String {
    localized("email_did_not_find_wine")
  }

  var cantFindWineRecipients: [String] {
    [localized("contact_email")]
  }

  func showAlertEmptyCollection() {
    viewController?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: localized("empty_collection"))
  }

  func stopPullRefreshing() {
    viewController?.stopPullRefreshing()
  }

  func startShimmer() {
    viewController?.updateUI(
      viewModel: VinchyViewControllerViewModel(
        state: .fake(sections: [
          .stories(.init(type: .stories(count: 10))),
          .title(.init(type: .title(count: 1))),
          .promo(.init(type: .promo(count: 10))),
          .title(.init(type: .title(count: 1))),
          .promo(.init(type: .big(count: 10))),
          .title(.init(type: .title(count: 1))),
          .promo(.init(type: .big(count: 10))),
          .title(.init(type: .title(count: 1))),
          .promo(.init(type: .big(count: 10))),
          .title(.init(type: .title(count: 1))),
          .promo(.init(type: .big(count: 10))),
        ])))
  }

  func startLoading() {
    viewController?.addLoader()
    viewController?.startLoadingAnimation()
  }

  func update(compilations: [Compilation], isSearchingMode: Bool) {
    viewController?.stopLoadingAnimation()

    var sections: [VinchyViewControllerViewModel.Section] = []

    for compilation in compilations {
      switch compilation.type {
      case .mini:
        if let title = compilation.title {
          sections.append(.title([
            .init(titleText: NSAttributedString(
              string: title,
              font: Font.heavy(20),
              textColor: .dark)),
          ]))
        }
        sections.append(.stories([
          .init(
            type: compilation.type,
            collections: compilation.collectionList),
        ]))

      case .big:
        if let title = compilation.title {
          sections.append(.title([
            .init(titleText: NSAttributedString(
              string: title,
              font: Font.heavy(20),
              textColor: .dark)),
          ]))
        }
        sections.append(.big([
          .init(
            type: compilation.type,
            collections: compilation.collectionList),
        ]))

      case .promo:
        if let title = compilation.title {
          sections.append(.title([
            .init(titleText: NSAttributedString(
              string: title,
              font: Font.heavy(20),
              textColor: .dark)),
          ]))
        }
        sections.append(.promo([
          .init(
            type: compilation.type,
            collections: compilation.collectionList),
        ]))

      case .bottles:
        if
          compilation.collectionList.first?.wineList != nil,
          let firstCollectionList = compilation.collectionList.first, !firstCollectionList.wineList.isEmpty
        {
          if let title = compilation.title {
            sections.append(.title([
              .init(titleText: NSAttributedString(
                string: title,
                font: Font.heavy(20),
                textColor: .dark)),
            ]))
          }

          sections.append(.bottles([
            .init(
              type: compilation.type,
              collections: compilation.collectionList),
          ]))
        }

      case .shareUs:
        sections.append(.shareUs([
          .init(titleText: localized("like_vinchy")),
        ]))

      case .smartFilter:
        sections.append(.smartFilter([
          .init(
            accentText: "New in Vinchy".uppercased(),
            boldText: "Personal compilations",
            subtitleText: "Answer on 3 questions & we find for you best wines.",
            buttonText: "Try now"),
        ]))
      }
    }

    sections.append(.title([
      .init(titleText:
        NSAttributedString(
          string: C.harmfulToYourHealthText,
          font: Font.light(15),
          textColor: .blueGray,
          paragraphAlignment: .justified)),
    ]))

    if !isSearchingMode {
      viewController?.updateUI(viewModel: VinchyViewControllerViewModel(state: .normal(sections: sections)))
    }
  }

  func update(suggestions: [Wine]) {
    var sections: [VinchyViewControllerViewModel.Section] = []

    suggestions.forEach { wine in
      sections.append(.suggestions([.init(titleText: wine.title)]))
    }

    viewController?.updateUI(viewModel: VinchyViewControllerViewModel(state: .normal(sections: sections)))
  }

  func update(didFindWines: [ShortWine]) {
    viewController?.updateUI(didFindWines: didFindWines)
  }

  func showAlertCantOpenEmail() {
    viewController?.showAlert(title: localized("error"), message: localized("open_mail_error"))
  }
}
