//
//  WineDetailPresenter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class WineDetailPresenter {

    private typealias ViewModel = WineDetailViewModel

    weak var viewController: WineDetailViewControllerProtocol?

    init(viewController: WineDetailViewControllerProtocol) {
        self.viewController = viewController
    }
}

// MARK: - WineDetailPresenterProtocol

extension WineDetailPresenter: WineDetailPresenterProtocol {

}
