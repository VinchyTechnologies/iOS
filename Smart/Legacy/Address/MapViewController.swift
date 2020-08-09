//
//  MapViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 04.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import MapKit
import Display

//protocol HandleMapSearch: AnyObject {
//    func dropPinZoomIn(placemark: MKPlacemark, address: String)
//}
//
//final class MapViewController: UIViewController, UISearchControllerDelegate, RealmProductProtocol {
//
//    private enum Constants {
//
//        static let bottomCartHeight: CGFloat = 48
//    }
//
//    var address: Address?
//    var cartViewController: CartViewController?
//    var addressesViewController: AddressesViewController?
//
//    private var bottomButton = UIButton()
//    private let addressLabel = UILabel()
//
//    var selectedPin: MKPlacemark?
//    var resultSearchController: UISearchController!
//
//    let locationManager = CLLocationManager()
//
//    let mapView = MKMapView()
//
//    override func loadView() {
//        super.loadView()
//        navigationController?.navigationBar.topItem?.backBarButtonItem =
//            UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//    }
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.addSubview(mapView)
//        mapView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            mapView.topAnchor.constraint(equalTo: view.topAnchor),
//            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//
//        addressLabel.translatesAutoresizingMaskIntoConstraints = false
//        addressLabel.numberOfLines = 5
//        addressLabel.textAlignment = .center
//        addressLabel.textColor = .dark
//        addressLabel.font = Font.regular(22)
//        mapView.addSubview(addressLabel)
//        NSLayoutConstraint.activate([
//            addressLabel.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 40),
//            addressLabel.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 30),
//            addressLabel.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -30)
//        ])
//        bottomButton.isHidden = true
//
//        bottomButton.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(bottomButton)
//
//        NSLayoutConstraint.activate([
//            bottomButton.heightAnchor.constraint(equalToConstant: Constants.bottomCartHeight),
//            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
//            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
//        ])
//
//        if cartViewController != nil {
//            bottomButton.setTitle("Доставить сюда", for: .normal)
//        } else {
//            bottomButton.setTitle("Сохранить", for: .normal)
//        }
//        bottomButton.backgroundColor = .mainColor
//        bottomButton.layer.cornerRadius = 20
//        bottomButton.titleLabel?.font = UIFont(name: "DINAlternate-Bold", size: 18)
//        bottomButton.titleLabel?.minimumScaleFactor = 0.3
//        bottomButton.titleLabel?.adjustsFontSizeToFitWidth = true
//        bottomButton.setTitleColor(.dark, for: .normal)
//        bottomButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//        bottomButton.addTarget(self, action: #selector(didTapBottomButton), for: .touchUpInside)
//
//
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
//        let locationSearchTable = LocationSearchTable()
//        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
//        resultSearchController.delegate = self
//        resultSearchController.searchResultsUpdater = locationSearchTable
//        let searchBar = resultSearchController!.searchBar
//        searchBar.tintColor = .dark
//        searchBar.placeholder = "Введите адрес доставки"
//        navigationItem.titleView = resultSearchController?.searchBar
//        resultSearchController.hidesNavigationBarDuringPresentation = false
//        definesPresentationContext = true
//        locationSearchTable.mapView = mapView
//        locationSearchTable.handleMapSearchDelegate = self
//
//    }
//
//    @objc private func didTapBottomButton() {
//
//        if let address = address {
//            saveAddress(address: address)
//        }
//
//        navigationController?.popViewController(animated: true)
//    }
//
//    func didPresentSearchController(_ searchController: UISearchController) {
//        DispatchQueue.main.async {
//            searchController.searchBar.becomeFirstResponder()
//        }
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        resultSearchController.isActive = true
//    }
//
//    @objc private func getDirections() {
//        guard let selectedPin = selectedPin else { return }
//        let mapItem = MKMapItem(placemark: selectedPin)
//        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//        mapItem.openInMaps(launchOptions: launchOptions)
//    }
//}
//
//extension MapViewController : CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .denied:
//            let alert = UIAlertController(title: "Location Services disabled",
//                                          message: "Please enable Location Services in Settings",
//                                          preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alert.addAction(okAction)
//            present(alert, animated: true, completion: nil)
//        case .authorizedAlways, .authorizedWhenInUse:
//            locationManager.requestLocation()
//        case .notDetermined, .restricted:
//            break
//        @unknown default:
//            break
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else { return }
//        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        let region = MKCoordinateRegion(center: location.coordinate, span: span)
//        mapView.setRegion(region, animated: true)
//    }
//
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        switch CLLocationManager.authorizationStatus() {
//        case .authorizedAlways, .authorizedWhenInUse:
//            let alert = UIAlertController(title: "Ошибка",
//                                          message: error.localizedDescription,
//                                          preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alert.addAction(okAction)
//            present(alert, animated: true, completion: nil)
//        case .notDetermined, .denied, .restricted:
//            break
//        @unknown default:
//            break
//        }
//    }
//
//}
//
//extension MapViewController: HandleMapSearch {
//
//    func dropPinZoomIn(placemark: MKPlacemark, address: String) {
//        // cache the pin
//        selectedPin = placemark
//        // clear existing pins
//        mapView.removeAnnotations(mapView.annotations)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = placemark.coordinate
//        annotation.title = placemark.name
//
//        if let city = placemark.locality,
//            let state = placemark.administrativeArea {
//            annotation.subtitle = "\(city) \(state)"
//        }
//
//        mapView.addAnnotation(annotation)
//        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
//        mapView.setRegion(region, animated: true)
//
//        showBottomView()
//        addressLabel.text = address
//        let address = Address(fullName: address, lat: placemark.coordinate.latitude, lon: placemark.coordinate.longitude)
//        cartViewController?.address = address
//        self.address = address
//    }
//
//    func showBottomView() {
//        bottomButton.isHidden = false
//    }
//
//}
//
//extension MapViewController : MKMapViewDelegate {
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        guard !(annotation is MKUserLocation) else { return nil }
//        let reuseId = "pin"
//        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
//        if pinView == nil {
//            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//        }
//        pinView?.pinTintColor = .lightGray
//        pinView?.canShowCallout = true
//        let smallSquare = CGSize(width: 30, height: 30)
//        let button = UIButton(frame: CGRect(origin: .zero, size: smallSquare))
////        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
//        button.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
//        pinView?.leftCalloutAccessoryView = button
//
//        return pinView
//    }
//}
//
