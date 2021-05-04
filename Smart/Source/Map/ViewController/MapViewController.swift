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
import VinchyCore

final class MapViewController: UIViewController {
  
  // MARK: - Internal Properties
  
  var interactor: MapInteractorProtocol?

  // MARK: - Private Properties

  private lazy var mapView: MKMapView = {
    let mapView = MKMapView()
    mapView.showsUserLocation = true
    mapView.delegate = self
    
    mapView.register(
      PartnerAnnotationView.self,
      forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    
    mapView.register(
      LocationDataMapClusterView.self,
      forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    
    let pan = UIPanGestureRecognizer(target: self, action: #selector(didDragMap(_:)))
    pan.delegate = self
    mapView.addGestureRecognizer(pan)
    
    let pinch = UIPinchGestureRecognizer(target: self, action: #selector(didPinchMap(_:)))
    pinch.delegate = self
    mapView.addGestureRecognizer(pinch)
    
    return mapView
  }()
  
  /*
  private lazy var backButton: UIButton = {
    let button = UIButton()
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    let backImage = UIImage(systemName: "chevron.left", withConfiguration: imageConfig)
    button.setImage(backImage, for: .normal)
    button.backgroundColor = .mainBackground
    button.tintColor = .dark
    button.clipsToBounds = true
    button.addTarget(self, action: #selector(didTapBackButton(_:)), for: .touchUpInside)
    return button
  }()
  */
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(mapView)
    mapView.fill()
    
    /*
    view.addSubview(backButton)
    backButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
      backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
      backButton.heightAnchor.constraint(equalToConstant: 48),
      backButton.widthAnchor.constraint(equalToConstant: 48),
    ])
     */
    
    interactor?.viewDidLoad()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
//    backButton.layer.cornerRadius = backButton.frame.height / 2
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  // MARK: - Private Methods
  
//  @objc
//  private func didTapBackButton(_ button: UIButton) {
//    navigationController?.popViewController(animated: true)
//  }
  
  @objc
  private func didDragMap(_ sender: UIGestureRecognizer) {
    if sender.state == .ended {
      interactor?.didMove(
        to: mapView.centerCoordinate,
        mapVisibleRegion: mapView.visibleMapRect,
        mapView: mapView,
        shouldUseThrottler: true)
    }
  }
  
  @objc
  private func didPinchMap(_ sender: UIGestureRecognizer) {
    if sender.state == .ended {
      interactor?.didMove(
        to: mapView.centerCoordinate,
        mapVisibleRegion: mapView.visibleMapRect,
        mapView: mapView,
        shouldUseThrottler: false)
    }
  }
}

// MARK: - UIGestureRecognizerDelegate

extension MapViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
    -> Bool
  {
    true
  }
}

// MARK: - MapViewControllerProtocol

extension MapViewController: MapViewControllerProtocol {
  
  func setUserLocation(_ userLocation: CLLocationCoordinate2D, radius: Double) {
    let viewRegion = MKCoordinateRegion(
      center: userLocation,
      latitudinalMeters: radius,
      longitudinalMeters: radius)
    mapView.setRegion(viewRegion, animated: false)
  }
  
  func updateUI(viewModel: MapViewModel) {
  }
  
  func updateUI(newPartnersOnMap: [PartnerAnnotationViewModel]) {
    mapView.addAnnotations(newPartnersOnMap)
  }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    switch annotation {
    case is PartnerAnnotationViewModel:
      var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier) as? PartnerAnnotationView
      if annotationView == nil {
        annotationView = PartnerAnnotationView(
        annotation: annotation,
        reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
      }
      annotationView?.clusteringIdentifier = String(describing: PartnerAnnotationView.self)
      return annotationView
      
    case is MKClusterAnnotation:
      var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier) as? LocationDataMapClusterView
      if annotationView == nil {
        annotationView = LocationDataMapClusterView(annotation: annotation, reuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
      }
      return annotationView
      
    default:
      return nil
    }    
  }
}
