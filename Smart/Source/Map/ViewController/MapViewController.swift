//
//  MapViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 02.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit
import MapKit

final class MapViewController: UIViewController {
  
  var interactor: MapInteractorProtocol?
  
  private lazy var mapView: MKMapView = {
    let mapView = MKMapView()
    return mapView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(mapView)
    mapView.fill()
    interactor?.viewDidLoad()
  }
}

// MARK: - MapViewControllerProtocol

extension MapViewController: MapViewControllerProtocol {
  
}
