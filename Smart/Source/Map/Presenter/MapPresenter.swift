//
//  MapPresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 02.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CoreLocation
import VinchyCore

final class MapPresenter {
  
  private typealias ViewModel = MapViewModel
  
  weak var viewController: MapViewControllerProtocol?
  private var partnersAnnotationViewModel: [PartnerAnnotationViewModel] = []
  
  init(viewController: MapViewControllerProtocol) {
    self.viewController = viewController
  }
}

// MARK: - MapPresenterProtocol

extension MapPresenter: MapPresenterProtocol {
  func updateUserLocationAndRegion(_ userLocation: CLLocationCoordinate2D, radius: Double) {
    viewController?.setUserLocation(userLocation, radius: radius)
  }
  
  func didReceive(partnersOnMap: Set<PartnerOnMap>) {
    
    var annotations: [PartnerAnnotationViewModel] = []
    let group = DispatchGroup()
    let locker = NSRecursiveLock()
    
    partnersOnMap.forEach { partnerOnMap in
      group.enter()
      DispatchQueue.global(qos: .userInitiated).async {
        partnerOnMap.affiliatedStores.forEach { affilatedStore in
          let annotationToAdd: PartnerAnnotationViewModel = .init(kind: .store(affilatedId: affilatedStore.id, title: affilatedStore.title, latitude: affilatedStore.latitude, longitude: affilatedStore.longitude))
          if self.partnersAnnotationViewModel.first(where: { $0 == annotationToAdd }) == nil {
            locker.lock()
            annotations.append(annotationToAdd)
            locker.unlock()
          }
        }
        group.leave()
      }
    }
    
    group.notify(queue: .main) {
      self.partnersAnnotationViewModel += annotations
      self.viewController?.updateUI(newPartnersOnMap: annotations)
    }
  }
}
