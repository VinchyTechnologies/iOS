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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(mapView)
    mapView.fill()
    
    mapView.addSubview(backButton)
    backButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
      backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
      backButton.heightAnchor.constraint(equalToConstant: 48),
      backButton.widthAnchor.constraint(equalToConstant: 48),
    ])
    interactor?.viewDidLoad()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    backButton.layer.cornerRadius = backButton.frame.height / 2
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  @objc
  private func didTapBackButton(_ button: UIButton) {
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - MapViewControllerProtocol

extension MapViewController: MapViewControllerProtocol {
  
}
