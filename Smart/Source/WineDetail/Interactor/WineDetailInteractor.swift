//
//  WineDetailInteractor.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class WineDetailInteractor {

    private let router: WineDetailRouterProtocol
    private let presenter: WineDetailPresenterProtocol

    init(
        router: WineDetailRouterProtocol,
        presenter: WineDetailPresenterProtocol)
    {
        self.router = router
        self.presenter = presenter
    }
}

// MARK: - WineDetailInteractorProtocol

extension WineDetailInteractor: WineDetailInteractorProtocol {

    func viewDidLoad() {
        
    }
}
