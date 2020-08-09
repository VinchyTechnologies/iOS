//
//  MoreConfigurator.swift
//  Coffee
//
//  Created by Алексей Смирнов on 10/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//

import UIKit
import StringFormatting

protocol MoreConfiguratorProtocol: AnyObject {
    func configure(with viewController: MoreViewController)
}

final class MoreConfigurator: MoreConfiguratorProtocol {
    func configure(with viewController: MoreViewController) {
        
        let presenter = MorePresenter(view: viewController)
        let interactor = MoreInteractor(presenter: presenter)
        let router = MoreRouter(viewController: viewController)
        
        presenter.interactor = interactor
        presenter.router = router
        
        viewController.presenter = presenter
        
    }
}
