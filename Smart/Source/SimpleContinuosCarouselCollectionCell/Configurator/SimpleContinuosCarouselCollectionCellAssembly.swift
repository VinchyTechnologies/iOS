//
//  SimpleContinuosCarouselCollectionCellAssembly.swift
//  Smart
//
//  Created by Михаил Исаченко on 14.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

final class SimpleContinuosCarouselCollectionCellConfigurator: Configurator {

  // MARK: Lifecycle

  init(delegate: SimpleContinuosCarouselCollectionCellInteractorDelegate?) {
    self.delegate = delegate
  }

  // MARK: Internal

  typealias ViewController = UIViewController

  typealias Input = SimpleContinuosCarouselCollectionCellInput

  typealias View = SimpleContinuousCaruselCollectionCellView


  weak var delegate: SimpleContinuosCarouselCollectionCellInteractorDelegate?

  func configure(view: SimpleContinuousCaruselCollectionCellView, with input: SimpleContinuosCarouselCollectionCellInput) {
    let router = SimpleContinuosCarouselCollectionCellRouter(input: input, viewController: nil)
    let presenter = SimpleContinuosCarouselCollectionCellPresenter(view: view)
    let interactor = SimpleContinuosCarouselCollectionCellInteractor(input: input, router: router, presenter: presenter)
    interactor.delegate = delegate

    router.interactor = interactor
    view.interactor = interactor
  }
}
