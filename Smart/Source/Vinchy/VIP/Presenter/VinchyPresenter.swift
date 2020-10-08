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

}

extension VinchyPresenter: VinchyPresenterProtocol {

    func update(sections: [VinchyViewControllerViewModel.Section]) {
        viewController?.updateUI(sections: sections)
    }

    func startLoading() {
        viewController?.addLoader()
        viewController?.startLoadingAnimation()
    }

    func update(compilations: [Compilation]) {
        viewController?.stopLoadingAnimation()

        var sections: [VinchyViewControllerViewModel.Section] = []

        for compilation in compilations {

            if let title = compilation.title {
                sections.append(.title([
                    .init(titleText: NSAttributedString(string: title,
                                                        font: Font.heavy(20),
                                                        textColor: .dark))
                ]))
            }

            switch compilation.type {
            case .mini:
                sections.append(.stories([
                    .init(type: compilation.type,
                          collections: compilation.collectionList)
                ]))

            case .big:
                sections.append(.big([
                    .init(type: compilation.type,
                          collections: compilation.collectionList)
                ]))

            case .promo:
                sections.append(.promo([
                    .init(type: compilation.type,
                          collections: compilation.collectionList)
                ]))

            case .bottles:
                sections.append(.bottles([
                    .init(type: compilation.type,
                          collections: compilation.collectionList)
                ]))

            case .shareUs:
                break

            case .infinity:
                break

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

        viewController?.updateUI(sections: sections)
    }

    func update(suggestions: [Wine]) {
        viewController?.updateSearchSuggestions(suggestions: suggestions)
    }
}
