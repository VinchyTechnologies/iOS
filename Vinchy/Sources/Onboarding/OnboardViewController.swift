//
//  OnboardViewController.swift
//  OnboardKit
//

import CoreLocation
import UIKit

// MARK: - OnboardingViewControllerOutput

protocol OnboardingViewControllerOutput: AnyObject {
  func didFinishWathingOnboarding()
}

// MARK: - OnboardingPageDelegate

protocol OnboardingPageDelegate: AnyObject {
  func didTapNexButton()
  func didTapCloseButton()
}

// MARK: - OnboardViewController

public class OnboardViewController: UIViewController {

  // MARK: Public

  public override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .mainBackground
    view.addSubview(pagerView)
    pagerView.fill()
  }

  // MARK: Internal

  weak var delegate: OnboardingViewControllerOutput?

  // MARK: Private

  private var currentPage = 0

  private lazy var layout: UICollectionViewFlowLayout = {
    $0.itemSize = view.frame.size
    $0.scrollDirection = .horizontal
    $0.minimumInteritemSpacing = 0
    $0.minimumLineSpacing = 0
    return $0
  }(UICollectionViewFlowLayout())

  private lazy var pagerView: UICollectionView = {
    $0.dataSource = self
    $0.isPagingEnabled = true
    $0.isScrollEnabled = false
    $0.register(GeoOnboardingViewController.self, FeaturesOnboardingViewController.self)
    return $0
  }(UICollectionView(frame: .zero, collectionViewLayout: layout))

  private var viewControllers: [UICollectionViewCell] {
    var result: [UICollectionViewCell] = [FeaturesOnboardingViewController()]
    if CLLocationManager.authorizationStatus() == .notDetermined {
      result += [GeoOnboardingViewController()]
    }
    return result
  }
}

// MARK: UICollectionViewDataSource

extension OnboardViewController: UICollectionViewDataSource {
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int)
    -> Int
  {
    viewControllers.count
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    if viewControllers[indexPath.row] as? GeoOnboardingViewController != nil {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GeoOnboardingViewController.reuseId, for: indexPath) as! GeoOnboardingViewController // swiftlint:disable:this force_cast
      cell.delegate = self
      return cell

    } else if viewControllers[indexPath.row] as? FeaturesOnboardingViewController != nil {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturesOnboardingViewController.reuseId, for: indexPath) as! FeaturesOnboardingViewController // swiftlint:disable:this force_cast
      cell.delegate = self
      return cell

    } else {
      return .init()
    }
  }
}

// MARK: OnboardingPageDelegate

extension OnboardViewController: OnboardingPageDelegate {

  func didTapNexButton() {
    currentPage += 1
    if currentPage < viewControllers.count {
      pagerView.setContentOffset(.init(x: view.frame.width * CGFloat(currentPage), y: 0), animated: true)
    } else {
      delegate?.didFinishWathingOnboarding()
    }
  }

  func didTapCloseButton() {
    delegate?.didFinishWathingOnboarding()
  }
}
