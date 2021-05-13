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
    
//    sections += [.navigationBar([.init()])]
    
    sections += [.title([.init(titleText: NSAttributedString(string: storeInfo.title, font: Font.bold(24), textColor: .dark, paragraphAlignment: .center))])]
    
    sections += [.address([.init(titleText: NSAttributedString(string: storeInfo.address ?? "Вернадский проспект, 16", font: Font.regular(18), textColor: .dark, paragraphAlignment: .center))])]

    sections += [.workingHours([.init(titleText: "19:00 - 20:00")])]

    sections += [.assortment([.init(titleText: "Посмотреть ассортимент")])]
    
    sections += [.title([.init(titleText: NSAttributedString(string: "Vinchy рекомендует", font: Font.heavy(20), textColor: .dark))])]
    sections += [.recommendedWines([.init(type: .bottles, collections: [.init(wineList: [.wine(wine: ShortWine.fake)])])])]
    
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
