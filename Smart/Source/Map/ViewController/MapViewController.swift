//
//  MapViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 02.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import Display
import MapKit
import StringFormatting
import UIKit
import VinchyCore

// MARK: - MapViewController

final class MapViewController: UIViewController, OpenURLProtocol {

  // MARK: Internal

  // MARK: - Internal Properties

  var interactor: MapInteractorProtocol?

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

    view.addSubview(routingToolBar)
    routingToolBar.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      routingToolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      routingToolBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      routingToolBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      routingToolBar.heightAnchor.constraint(equalToConstant: 48),
    ])

    view.addSubview(searchInThisAreaButton)
    searchInThisAreaButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      searchInThisAreaButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      searchInThisAreaButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      searchInThisAreaButton.heightAnchor.constraint(equalToConstant: 40),
    ])

    interactor?.viewDidLoad()
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    searchInThisAreaButton.layer.cornerRadius = searchInThisAreaButton.frame.height / 2
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }

  // MARK: Private

  // MARK: - Private Properties

  private var selectedAnnotation: MKAnnotation?

  private lazy var mapView: MKMapView = {
    let mapView = MKMapView()
    mapView.showsUserLocation = true
    mapView.delegate = self
    mapView.tintColor = .accent

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

  private lazy var routingToolBar: RoutingToolBar = {
    $0.delegate = self
    $0.isHidden = true
    return $0
  }(RoutingToolBar())

  private lazy var searchInThisAreaButton: UIButton = {
    $0.backgroundColor = .mainBackground
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold, scale: .default)
    $0.setImage(UIImage(systemName: "goforward")?.withTintColor(.accent, renderingMode: .alwaysOriginal).withConfiguration(imageConfig), for: [])
    $0.imageView?.contentMode = .scaleAspectFit
    let transform = CGAffineTransform(rotationAngle: .pi / 2)
    $0.imageView?.transform = transform
    $0.setTitle(localized("search_this_area"), for: [])
    $0.setTitleColor(.dark, for: [])
    $0.contentEdgeInsets = .init(top: 10, left: 14, bottom: 10, right: 14)
    $0.imageEdgeInsets = .init(top: 0, left: -6, bottom: 0, right: 4)
    $0.titleLabel?.font = Font.bold(14)
    $0.alpha = 0
    $0.addTarget(self, action: #selector(didTapSearchThisAreaButton(_:)), for: .touchUpInside)
    $0.startAnimatingPressActions()
    return $0
  }(UIButton())

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

  // MARK: - Private Methods

  //  @objc
  //  private func didTapBackButton(_ button: UIButton) {
//    navigationController?.popViewController(animated: true)
  //  }

  @objc
  private func didDragMap(_ sender: UIGestureRecognizer) {
    if sender.state == .ended {
      if routingToolBar.isHidden {
        if searchInThisAreaButton.alpha == 0 {
          UIView.animate(withDuration: 0.25) {
            self.searchInThisAreaButton.alpha = 1
          }
        }
      }
    }
  }

  @objc
  private func didPinchMap(_ sender: UIGestureRecognizer) {
    if sender.state == .ended {
      if routingToolBar.isHidden {
        if searchInThisAreaButton.alpha == 0 {
          UIView.animate(withDuration: 0.25) {
            self.searchInThisAreaButton.alpha = 1
          }
        }
      }
    }
  }

  @objc
  private func didTapSearchThisAreaButton(_: UIButton) {
    interactor?.didTapSearchThisAreaButton(position: mapView.centerCoordinate, radius: mapView.currentRadius())
  }
}

// MARK: UIGestureRecognizerDelegate

extension MapViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(
    _: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer)
    -> Bool
  {
    true
  }
}

// MARK: MapViewControllerProtocol

extension MapViewController: MapViewControllerProtocol {
  func removeAllOverlays() {
    let overlays = mapView.overlays
    mapView.removeOverlays(overlays)
  }

  func setUserLocation(_ userLocation: CLLocationCoordinate2D, radius: Double) {
    let viewRegion = MKCoordinateRegion(
      center: userLocation,
      latitudinalMeters: radius,
      longitudinalMeters: radius)
    mapView.setRegion(viewRegion, animated: false)
  }

  func deselectSelectedPin() {
    mapView.selectedAnnotations.forEach { annotation in
      mapView.deselectAnnotation(annotation, animated: true)
    }
  }

  func updateUI(viewModel _: MapViewModel) {}

  func updateUI(newPartnersOnMap: [PartnerAnnotationViewModel]) {
    if searchInThisAreaButton.alpha == 1.0 {
      UIView.animate(withDuration: 0.25) {
        self.searchInThisAreaButton.alpha = 0.0
      }
    }
    mapView.annotations.forEach { mapView.removeAnnotation($0) }
    mapView.addAnnotations(newPartnersOnMap)
  }

  func drawRoute(route: MKRoute) {
    guard let selectedAnnotation = selectedAnnotation as? PartnerAnnotationViewModel else {
      return
    }
    mapView.annotations.forEach { annotation in
      if (annotation as? PartnerAnnotationViewModel) != selectedAnnotation {
        mapView.removeAnnotation(annotation)
      }
    }
    mapView.removeOverlays(mapView.overlays)
    mapView.addOverlay(route.polyline, level: .aboveRoads)
    guard let viewFrame = mapView.view(for: selectedAnnotation)?.frame else {
      return
    }

    mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: .init(top: viewFrame.width / 2 + 20, left: viewFrame.width / 2 + 20, bottom: viewFrame.width / 2 + 20, right: viewFrame.width / 2 + 20), animated: true)

    let string = NSAttributedString(
      string:
      ("~" + (route.expectedTravelTime.toString() ?? ""))
        + " • "
        + (route.distance.toDistance() ?? ""),
      font: Font.semibold(20),
      textColor: .dark,
      paragraphAlignment: .center)

    routingToolBar.decorate(model: .init(distanceText: string))
    routingToolBar.isHidden = false

    if searchInThisAreaButton.alpha == 1.0 {
      UIView.animate(withDuration: 0.25) {
        self.searchInThisAreaButton.alpha = 0.0
      }
    }
  }
}

// MARK: MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
  func mapView(_: MKMapView, didDeselect view: MKAnnotationView) {
    UIView.animate(
      withDuration: 0.4,
      delay: 0,
      usingSpringWithDamping: 0.5,
      initialSpringVelocity: 0.8,
      options: .curveEaseIn) {
        view.transform = .identity
    } completion: { _ in
    }
    selectedAnnotation = nil
  }

  func mapView(_: MKMapView, didSelect view: MKAnnotationView) {
    if let annotation = view.annotation as? PartnerAnnotationViewModel {
      UIView.animate(
        withDuration: 0.3,
        delay: 0,
        usingSpringWithDamping: 0.5,
        initialSpringVelocity: 0.8,
        options: .curveEaseIn) {
          view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).translatedBy(x: 0, y: -10)
      } completion: { _ in
        self.selectedAnnotation = annotation
        self.interactor?.didTapOnPin(
          partnerId: annotation.partnerId,
          affilatedId: annotation.affilatedId)
      }
    }
  }

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    switch annotation {
    case is PartnerAnnotationViewModel:
      var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier) as? PartnerAnnotationView
      if annotationView == nil {
        annotationView = PartnerAnnotationView(
          annotation: annotation,
          reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
      }
      if (annotation as? PartnerAnnotationViewModel)?.shouldCluster == true {
        annotationView?.clusteringIdentifier = String(describing: PartnerAnnotationView.self)
      }

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

  func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = .accent
    renderer.lineWidth = 4.0
    return renderer
  }
}

// MARK: MapDetailStoreViewControllerDelegate

extension MapViewController: MapDetailStoreViewControllerDelegate {
  func didTapAssortmentButton(_: UIButton) {
    if let viewModel = (selectedAnnotation as? PartnerAnnotationViewModel) {
      interactor?.didTapAssortmentButton(
        partnerId: viewModel.partnerId,
        affilatedId: viewModel.affilatedId,
        title: viewModel.title)
    }
  }

  func didTapRouteButton(_: UIButton) {
    if let coordinate = selectedAnnotation?.coordinate {
      interactor?.didTapShowRouteOnBottomSheet(coordinate: coordinate)
    }
  }
}

// MARK: RoutingToolBarDelegate

extension MapViewController: RoutingToolBarDelegate {
  func didTapXMarkButton(_: UIButton) {
    routingToolBar.isHidden = true
    interactor?.didTapXMarkButtonOnRoutingToolBar()
    interactor?.didTapSearchThisAreaButton(position: mapView.centerCoordinate, radius: mapView.currentRadius())
  }

  func didTapOpenInAppButton(_ button: UIButton) {
    if let pin = selectedAnnotation as? PartnerAnnotationViewModel {
      let alert = UIAlertController(title: localized("open_in_app").firstLetterUppercased(), message: nil, preferredStyle: .actionSheet)
      alert.addAction(UIAlertAction(title: localized("apple_maps").firstLetterUppercased(), style: .default, handler: { _ in
        let appleURL = "http://maps.apple.com/?ll=\(pin.coordinate.latitude),\(pin.coordinate.longitude)&q=\(pin.title ?? "Vinchy")&z=15"
        self.open(urlString: appleURL, errorCompletion: {})
      }))

      alert.addAction(UIAlertAction(title: localized("cancel").firstLetterUppercased(), style: .cancel, handler: { _ in
      }))

      alert.view.tintColor = .accent

      alert.popoverPresentationController?.sourceView = button
      alert.popoverPresentationController?.permittedArrowDirections = .up

      present(alert, animated: true)
    }
  }
}
