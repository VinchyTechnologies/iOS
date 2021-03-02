//
//  MapInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 02.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class MapInteractor {
  
  private let router: MapRouterProtocol
  private let presenter: MapPresenterProtocol
  
  init(
    router: MapRouterProtocol,
    presenter: MapPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }
}

// MARK: - MapInteractorProtocol

extension MapInteractor: MapInteractorProtocol {
  
  func viewDidLoad() {
    
  }
}
