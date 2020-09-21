//
//  VinchyInteractor.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation
import VinchyCore

final class VinchyInteractor {

    private enum C {

    }

    private let dispatchGroup = DispatchGroup()


    private let router: VinchyRouterProtocol
    private let presenter: VinchyPresenterProtocol

    init(router: VinchyRouterProtocol,
         presenter: VinchyPresenterProtocol) {
        self.router = router
        self.presenter = presenter
    }

//    private func fetchData() {
//
//        dispatchGroup.enter()
//        var compilations: [Compilation] = []
//        Compilations.shared.getCompilations { [weak self] result in
//            switch result {
//            case .success(let model):
//                compilations = model
//            case .failure:
//                break
//            }
//            self?.dispatchGroup.leave()
//        }
//
//        var infinityWines: [Wine] = []
//        dispatchGroup.enter()
//        Wines.shared.getRandomWines(count: 10) { [weak self] result in
//            switch result {
//            case .success(let model):
//                infinityWines = model
//            case .failure:
//                break
//            }
//            self?.dispatchGroup.leave()
//        }
//
//        dispatchGroup.notify(queue: .main) { [weak self] in
//            guard let self = self else { return }
//            self.dispatchWorkItemHud.cancel()
//            self.stopLoadingAnimation()
//
//            let shareUs = Compilation(type: .shareUs, title: nil, collectionList: [])
//            compilations.insert(shareUs, at: compilations.isEmpty ? 0 : compilations.count - 1)
//
//            if infinityWines.isEmpty {
//                self.compilations = compilations
//            } else {
//                self.adLoader.load(DFPRequest())
//                self.collectionList = infinityWines.map({ .wine(wine: $0) })
//                let collection = Collection(wineList: self.collectionList)
//                compilations.append(Compilation(type: .infinity, title: "You can like", collectionList: [collection]))
//                self.compilations = compilations
//            }
//        }
//
//        Wines.shared.getRandomWines(count: 10) { [weak self] result in
//            switch result {
//            case .success(let model):
//                self?.suggestions = model
//            case .failure:
//                break
//            }
//        }
//    }
}


extension VinchyInteractor: VinchyInteractorProtocol {
    func viewDidLoad() {
//        fetchData()
    }
}
