//
//  VinchyRouter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class VinchyRouter {

    weak var viewController: UIViewController?
    weak var interactor: VinchyInteractorProtocol?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension VinchyRouter: VinchyRouterProtocol {

    func pushToAdvancedFilterViewController() {
        viewController?.navigationController?.pushViewController(Assembly.buildFiltersModule(), animated: true)
    }

    func pushToDetailCollection(searchText: String) {
        viewController?.navigationController?.pushViewController(Assembly.buildShowcaseModule(navTitle: nil, mode: .advancedSearch(params: [("title", searchText)])), animated: true)
    }
}
