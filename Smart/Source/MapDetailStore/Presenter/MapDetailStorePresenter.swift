//
//  MapDetailStorePresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import VinchyCore

final class MapDetailStorePresenter {
    
  weak var viewController: MapDetailStoreViewControllerProtocol?
  
  init(viewController: MapDetailStoreViewControllerProtocol) {
    self.viewController = viewController
  }
}

// MARK: - MapDetailStorePresenterProtocol

extension MapDetailStorePresenter: MapDetailStorePresenterProtocol {
  
  func update(storeInfo: PartnerInfo) {
    var sections: [MapDetailStoreViewModel.Section] = []
    sections += [.title([.init(titleText: NSAttributedString(string: storeInfo.title, font: Font.bold(24), textColor: .dark, paragraphAlignment: .center))])]
    viewController?.updateUI(viewModel: .init(sections: sections))
  }
  
  func startLoading() {
    viewController?.startLoadingAnimation()
    viewController?.addLoader()
  }
  
  func stopLoading() {
    viewController?.stopLoadingAnimation()
  }
}
