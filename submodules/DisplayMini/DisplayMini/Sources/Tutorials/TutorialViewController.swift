//
//  TutorialViewController.swift
//  DeliveryClub
//
//  Created by r.kuchukbaev on 21.01.2020.
//  Copyright © 2020 Delivery Club. All rights reserved.
//

import UIKit

// MARK: - TutorialContentViewProtocol

public protocol TutorialContentViewProtocol where Self: UIView {
  func hide()
  func animateAppear(completion: (() -> Void)?)
  func animateDisappear(completion: (() -> Void)?)
}

// MARK: - TutorialViewController

public final class TutorialViewController: OverlayPresentableViewController {

  // MARK: Public

  public weak var presentableDelegate: OverlayPresentableDelegate?

  public var tutorialView: TutorialContentViewProtocol? {
    didSet {
      if isViewLoaded {
        oldValue?.removeFromSuperview()
        setupTutorialView()
      }
    }
  }

  public var anchorPoint: CGPoint = .init(x: 0.5, y: 0.5) {
    didSet {
      if isViewLoaded {
        tutorialView?.removeFromSuperview()
        setupTutorialView()
      }
    }
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Constants.backgroundColor
    setupTutorialView()
    tutorialView?.hide()
    let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
    view.addGestureRecognizer(tap)
  }

  override public func viewWillAppear(_ animated: Bool) {
    tutorialView?.animateAppear(completion: {
      Timer.scheduledTimer(withTimeInterval: Constants.tutorialShowDuration, repeats: false) { [weak self] _ in
        guard let self = self else { return }
        self.tutorialView?.animateDisappear(completion: { [weak self] in
          self?.dismiss()
        })
      }
    })
  }

  // MARK: Internal

  enum Constants {
    static let backgroundColor = UIColor.black.withAlphaComponent(0.5)
    static let tutorialShowDuration: Double = 5.5
  }

  // MARK: Private

  private func setupTutorialView() {
    guard let tutorialView = tutorialView else { return }

    tutorialView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tutorialView)

    NSLayoutConstraint.activate([
      tutorialView.topAnchor.constraint(
        equalTo: view.topAnchor,
        constant: tutorialView.frame.origin.y + ((anchorPoint.y - 0.5) * tutorialView.frame.size.height)),
      tutorialView.leadingAnchor.constraint(
        equalTo: view.leadingAnchor,
        constant: tutorialView.frame.origin.x + ((anchorPoint.x - 0.5) * tutorialView.frame.size.width)),
      tutorialView.widthAnchor.constraint(equalToConstant: tutorialView.frame.size.width),
      tutorialView.heightAnchor.constraint(equalToConstant: tutorialView.frame.size.height),
    ])
  }

  @objc
  private func backgroundTapped(_ sender: Any) {
    dismiss()
  }

  private func dismiss() {
    dismiss(animated: true) {
      self.presentableDelegate?.overlayPresentableDidDismiss(self)
    }
  }
}

extension TutorialViewController {

  // MARK: Public

  public static func build(with viewModel: DeliveryTutorialViewModel, sourceViewFrame: CGRect, availiableWidth: CGFloat, activeRect: CGRect) -> TutorialViewController? {
    var tutorialView = makeTutorialView(viewModel: viewModel, width: availiableWidth, point: sourceViewFrame.origin, anchorPoint: .topLeft)
    guard
      !activeRect.contains(tutorialView.frame)
    else {
      return createTutorialViewController(with: tutorialView)
    }

    let bottomCorner = CGPoint(x: sourceViewFrame.origin.x, y: sourceViewFrame.origin.y + sourceViewFrame.height)
    tutorialView = makeTutorialView(viewModel: viewModel, width: availiableWidth, point: bottomCorner, anchorPoint: .bottomLeft)
    let oldFrame = tutorialView.frame
    let newFrame = CGRect(origin: .init(x: oldFrame.origin.x, y: oldFrame.origin.y - oldFrame.height), size: oldFrame.size)
    guard activeRect.contains(newFrame) else { return nil }
    return createTutorialViewController(with: tutorialView)
  }

  // MARK: Private

  private enum AnchorType {
    case topLeft
    case bottomLeft

    var point: CGPoint {
      switch self {
      case .topLeft: return CGPoint(x: 0, y: 0)
      case .bottomLeft: return CGPoint(x: 0, y: 1)
      }
    }
  }

  private static func createTutorialViewController(with tutorialView: DeliveryTutorialView) -> TutorialViewController {
    let viewController = TutorialViewController()
    viewController.tutorialView = tutorialView
    viewController.anchorPoint = .zero
    viewController.modalTransitionStyle = .crossDissolve
    viewController.modalPresentationStyle = .overFullScreen
    return viewController
  }

  private static func makeTutorialView(viewModel: DeliveryTutorialViewModel, width: CGFloat, point: CGPoint, anchorPoint: AnchorType) -> DeliveryTutorialView {
    let view = DeliveryTutorialView.loadNib()
    let size = DeliveryTutorialView.size(viewModel: viewModel, width: width)
    view.frame = CGRect(origin: point, size: size)
    view.anchorpoint = anchorPoint.point
    view.reload(viewModel: viewModel)
    return view
  }

}

// MARK: - ViewLoading

public protocol ViewLoading {}

// MARK: - UIView + ViewLoading

extension UIView: ViewLoading {}

extension ViewLoading where Self: UIView {
  public static func loadNib() -> Self {
    let bundle = Bundle(for: Self.self)
    guard
      bundle.path(forResource: className, ofType: "nib") != nil,
      let view = UINib(nibName: className, bundle: bundle).instantiate(withOwner: self, options: nil).first as? Self
    else { return Self() }
    return view
  }
}

extension NSObjectProtocol {

  public static var className: String {
    String(describing: self)
  }

  public var className: String {
    type(of: self).className
  }
}
