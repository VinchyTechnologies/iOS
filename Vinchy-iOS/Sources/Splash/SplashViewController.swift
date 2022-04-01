//
//  SplashViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 01.04.2022.
//  Copyright © 2022 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - SplashService

final class SplashService {

  // MARK: Lifecycle

  private init() {

  }

  // MARK: Internal

  enum SplashState {
    case normal, unsupportedVersion
  }

  static let shared = SplashService()

  private(set) var state: SplashState = .normal

  func update(state: SplashState) {
    self.state = state
  }
}

// MARK: - SplashViewController

final class SplashViewController: UIViewController {

  // MARK: Lifecycle

  init(splashService: SplashService) {
    self.splashService = splashService
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  var onEndAnimation: (() -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .secondarySystemBackground

    let imageView = UIImageView(frame: .init(origin: .zero, size: .init(width: 350, height: 350)))
    imageView.image = UIImage(named: "logo")
    imageView.contentMode = .scaleAspectFit

    view.directionalLayoutMargins = .zero
    view.layoutMargins = .zero
    view.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 5 /* magic number, bug of launch screen*/),
      imageView.widthAnchor.constraint(equalToConstant: 350),
      imageView.heightAnchor.constraint(equalToConstant: 350),
    ])
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    let defaultValue = ["force_update_versions": [String]() as NSObject]
    remoteConfig.setDefaults(defaultValue)

    remoteConfig.fetch { [weak self] _, error in
      if error == nil {
        remoteConfig.activate(completion: nil)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, let versions = remoteConfig.configValue(forKey: "force_update_versions").jsonValue as? [String] {
          if versions.contains(version) {
            self?.splashService.update(state: .unsupportedVersion)
            self?.onEndAnimation?()
          } else {
            self?.splashService.update(state: .normal)
            self?.onEndAnimation?()
          }
        } else {
          self?.splashService.update(state: .normal)
          self?.onEndAnimation?()
        }
      } else {
        self?.splashService.update(state: .normal)
        self?.onEndAnimation?()
      }
    }
  }

  // MARK: Private

  private let splashService: SplashService

}
