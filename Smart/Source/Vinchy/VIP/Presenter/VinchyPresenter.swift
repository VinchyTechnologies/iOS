//
//  VinchyPresenter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class VinchyPresenter {

    private enum C {

    }

//    typealias ViewModel = SlotsViewModel

    weak var viewController: VinchyViewControllerProtocol?

    init(viewController: VinchyViewControllerProtocol) {
        self.viewController = viewController
    }

}

extension VinchyPresenter: VinchyPresenterProtocol {


}
