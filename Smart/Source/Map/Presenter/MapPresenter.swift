//
//  MapPresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 02.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import CoreLocation
import VinchyCore
import MapKit

final class MapPresenter {
    
  weak var viewController: MapViewControllerProtocol?
  private var partnersAnnotationViewModel: [PartnerAnnotationViewModel] = []
  
  init(viewController: MapViewControllerProtocol) {
    self.viewController = viewController
  }
}

// MARK: - MapPresenterProtocol

extension MapPresenter: MapPresenterProtocol {
  
  func removeAllOverlays() {
    viewController?.removeAllOverlays()
  }
  
  func setRoutingToolBarHidden(_ flag: Bool) {
    viewController?.setRoutingToolBarHidden(flag)
  }
  
  func deselectSelectedPin() {
    viewController?.deselectSelectedPin()
  }
  
  func didReceive(route: MKRoute) {
    viewController?.drawRoute(route: route)
    viewController?.setRoutingToolBarHidden(false)
  }
  
  func updateUserLocationAndRegion(_ userLocation: CLLocationCoordinate2D, radius: Double) {
    viewController?.setUserLocation(userLocation, radius: radius)
  }
  
  func didReceive(partnersOnMap: Set<PartnerOnMap>) {
    
    var annotations: [PartnerAnnotationViewModel] = []
    let group = DispatchGroup()
    var locker = os_unfair_lock()
    
    partnersOnMap.forEach { partnerOnMap in
      group.enter()
      DispatchQueue.global(qos: .userInitiated).async {
        partnerOnMap.affiliatedStores.forEach { affilatedStore in
          let annotationToAdd: PartnerAnnotationViewModel = .init(
            kind: .store(
              partnerId: partnerOnMap.id,
              affilatedId: affilatedStore.id,
              title: affilatedStore.title,
              latitude: affilatedStore.latitude,
              longitude: affilatedStore.longitude))
          
          if self.partnersAnnotationViewModel.first(where: { $0 == annotationToAdd }) == nil {
            os_unfair_lock_lock(&locker)
            annotations.append(annotationToAdd)
            os_unfair_lock_unlock(&locker)
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
