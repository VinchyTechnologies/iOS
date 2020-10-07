//
//  AgreementsModuleFactory.swift
//  Smart
//
//  Created by Aleksei Smirnov on 29.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class AgreementsModuleFactory {

    func makeAgreementsViewController(
        delegate: AgreementsViewControllerOutput?)
        -> AgreementsViewController
    {
        let viewController = AgreementsViewController()
        viewController.delegate = delegate
        return viewController
    }
}
