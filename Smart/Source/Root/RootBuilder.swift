//
//  RootBuilder.swift
//  Smart
//
//  Created by Алексей Смирнов on 17.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

struct RootBuilderInput {
    let window: UIWindow
}

protocol RootBuilder {
    func build(input: RootBuilderInput) -> RootInteractor & RootDeeplinkable
}

final class RootBuilderImpl: RootBuilder {
    private let tabBarBuilder: TabBarBuilder

    init(tabBarBuilder: TabBarBuilder) {
        self.tabBarBuilder = tabBarBuilder
    }

    func build(input: RootBuilderInput) -> RootInteractor & RootDeeplinkable {
        let router = RootRouterImpl(window: input.window, tabBarBuilder: tabBarBuilder)
        let interactor = RootInteractorImpl(router: router)
        return interactor
    }
}
