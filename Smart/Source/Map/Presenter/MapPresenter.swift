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
import StringFormatting

final class MapPresenter {
    
  weak var viewController: MapViewControllerProtocol?
  
  init(viewController: MapViewControllerProtocol) {
    self.viewController = viewController
  }
}

// MARK: - MapPresenterProtocol

extension MapPresenter: MapPresenterProtocol {
  
  func showAlert(error: Error) {
    viewController?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: error.localizedDescription)
  }
  
  func removeAllOverlays() {
    viewController?.removeAllOverlays()
  }
  
  func deselectSelectedPin() {
    viewController?.deselectSelectedPin()
  }
  
  func didReceive(route: MKRoute) {
    viewController?.drawRoute(route: route)
  }
  
  func updateUserLocationAndRegion(_ userLocation: CLLocationCoordinate2D, radius: Double) {
    viewController?.setUserLocation(userLocation, radius: radius)
  }
  
  func didReceive(partnersOnMap: Set<PartnerOnMap>, userLocation: CLLocationCoordinate2D?) {
    
    var annotations: [PartnerAnnotationViewModel] = []
    let group = DispatchGroup()
    var locker = os_unfair_lock()
    
    partnersOnMap.forEach { partnerOnMap in
      group.enter()
      DispatchQueue.global(qos: .userInitiated).async {
                
        partnerOnMap.affiliatedStores.forEach { affilatedStore in
          let shouldCluster: Bool
          if userLocation == nil {
            shouldCluster = true
          } else {
            shouldCluster = CLLocation.distance(from: userLocation!, to: .init(latitude: affilatedStore.latitude, longitude: affilatedStore.longitude)) > 1000 //swiftlint:disable:this force_unwrapping
          }
          let annotationToAdd: PartnerAnnotationViewModel = .init(
            kind: .store(
              partnerId: partnerOnMap.id,
              affilatedId: affilatedStore.id,
              title: affilatedStore.title,
              latitude: affilatedStore.latitude,
              longitude: affilatedStore.longitude,
              shouldCluster: shouldCluster))
          
            os_unfair_lock_lock(&locker)
            annotations.append(annotationToAdd)
            os_unfair_lock_unlock(&locker)
        }
        group.leave()
      }
    }
    
    group.notify(queue: .main) {
      self.viewController?.updateUI(newPartnersOnMap: annotations)
    }
  }
}
