//
//  VinchyPresenter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display
import VinchyCore
import StringFormatting

final class VinchyPresenter {

  private enum C {
    static let harmfulToYourHealthText = localized("harmful_to_your_health")
  }

  weak var viewController: VinchyViewControllerProtocol?

  init(viewController: VinchyViewControllerProtocol) {
    self.viewController = viewController
  }

  private func addTitle(_ title: String?) {

  }

}

extension VinchyPresenter: VinchyPresenterProtocol {

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

  var cantFindWineText: String {
    localized("email_did_not_find_wine")
  }

  var cantFindWineRecipients: [String] {
    [localized("contact_email")]
  }

  func startLoading() {
    viewController?.addLoader()
    viewController?.startLoadingAnimation()
  }

  func update(compilations: [Compilation]) {
    viewController?.stopLoadingAnimation()

    var sections: [VinchyViewControllerViewModel.Section] = []

    for compilation in compilations {

      switch compilation.type {
      case .mini:
        if let title = compilation.title {
          sections.append(.title([
            .init(titleText: NSAttributedString(string: title,
                                                font: Font.heavy(20),
                                                textColor: .dark))
          ]))
        }
        sections.append(.stories([
          .init(type: compilation.type,
                collections: compilation.collectionList)
        ]))

      case .big:
        if let title = compilation.title {
          sections.append(.title([
            .init(titleText: NSAttributedString(string: title,
                                                font: Font.heavy(20),
                                                textColor: .dark))
          ]))
        }
        sections.append(.big([
          .init(type: compilation.type,
                collections: compilation.collectionList)
        ]))

      case .promo:
        if let title = compilation.title {
          sections.append(.title([
            .init(titleText: NSAttributedString(string: title,
                                                font: Font.heavy(20),
                                                textColor: .dark))
          ]))
        }
        sections.append(.promo([
          .init(type: compilation.type,
                collections: compilation.collectionList)
        ]))

      case .bottles:
        if compilation.collectionList.first?.wineList != nil && !(compilation.collectionList.first?.wineList.isEmpty == true) {

          if let title = compilation.title {
            sections.append(.title([
              .init(titleText: NSAttributedString(string: title,
                                                  font: Font.heavy(20),
                                                  textColor: .dark))
            ]))
          }

          sections.append(.bottles([
            .init(type: compilation.type,
                  collections: compilation.collectionList)
          ]))
        }

      case .shareUs:
        sections.append(.shareUs([
          .init(titleText: localized("like_vinchy"))
        ]))

      case .smartFilter:
        break
      }
    }

    sections.append(.title([
      .init(titleText:
              NSAttributedString(string: C.harmfulToYourHealthText,
                                 font: Font.light(15),
                                 textColor: .blueGray,
                                 paragraphAlignment: .justified))
    ]))

    viewController?.updateUI(viewModel: VinchyViewControllerViewModel(state: .normal(sections: sections)))
  }

  func update(suggestions: [Wine]) {
    viewController?.updateSearchSuggestions(suggestions: suggestions)
  }

  func update(didFindWines: [Wine]) {
    viewController?.updateUI(didFindWines: didFindWines)
  }

  func showAlertCantOpenEmail() {
    viewController?.showAlert(title: localized("error"), message: localized("open_mail_error"))
  }
}
