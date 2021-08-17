//
//  SimpleContinuosCarouselCollectionCellAssembly.swift
//  Smart
//
//  Created by Михаил Исаченко on 14.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

final class SimpleContinuosCarouselCollectionCellConfigurator: Configurator {

  typealias ViewController = UIViewController

  typealias Input = SimpleContinuosCarouselCollectionCellInput

  typealias View = SimpleContinuousCaruselCollectionCellView

  func configure(view: SimpleContinuousCaruselCollectionCellView, with input: SimpleContinuosCarouselCollectionCellInput, sender: UIViewController) {
    let router = SimpleContinuosCarouselCollectionCellRouter(input: input, viewController: sender)
    let presenter = SimpleContinuosCarouselCollectionCellPresenter(view: view)
    let interactor = SimpleContinuosCarouselCollectionCellInteractor(input: input, router: router, presenter: presenter)

    router.interactor = interactor
    view.interactor = interactor
  }
}
