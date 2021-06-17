//
//  FadingInfoViewController.swift
//  Display
//
//  Created by Алексей Смирнов on 10.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//
// switlint:disable all

import UIKit

// MARK: - FadingInfoViewController

open class FadingInfoViewController: UIViewController {

  // MARK: Lifecycle

  // MARK: - Init

  public init(
    headerViewController: HeaderViewController,
    contentViewController: ContentViewController,
    presentationCenter: OverlayPresentationCenterProtocol?)
  {
    self.headerViewController = headerViewController
    self.contentViewController = contentViewController
    self.presentationCenter = presentationCenter
    super.init(nibName: nil, bundle: nil)
    hidesBottomBarWhenPushed = true
  }

  @available(*, unavailable)
  public required init?(coder _: NSCoder) {
    nil
  }

  // MARK: Open

  // MARK: - Overrides

  override open func viewDidLoad() {
    headerViewController.delegate = self
    super.viewDidLoad()
    view.backgroundColor = Constants.backgroundColor
    configureHeaderContainer()
    configureContentDecoratorView()
    showContentViewController(contentViewController)
    configureHeaderViewController()
  }

  // MARK: Public

  public typealias ContentViewController = FadingInfoContentViewProtocol & UIViewController
  public typealias HeaderViewController = FadingInfoHeaderViewProtocol & UIViewController

  override public var navigationItem: UINavigationItem {
    contentViewController.navigationItem
  }

  override public func loadView() {
    view = {
      let view = FadingInfoView()
      view.delegate = self
      return view
    }()
  }

  override public func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.barTintColor = Constants.backgroundColor
  }

  override public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    updateDecoratorViewShadow()
  }

  override public func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.barTintColor = UINavigationBar.appearance().barTintColor
  }

  public final func showContentViewController(_ viewController: ContentViewController) {
    contentViewController.unembedFromParentIfNeeded()
    contentViewController = viewController
    viewController.viewDelegate = self
    embedChild(viewController)
    viewController.view.backgroundColor = .clear
    updateForContentViewHeight(viewController)
  }

  // MARK: Private

  private enum Constants {
    static let backgroundColor = UIColor.lightGray
    static let contentDecoratorView = (
      backgroundColor: UIColor.white,
      cornerRadius: CGFloat(16),
      shadow: (
        color: UIColor.black.cgColor,
        opacity: Float(0.04),
        offset: CGSize(width: 0, height: -2),
        radius: CGFloat(8)))
    static let transition = (
      shadow: (
        fadingSpeed: CGFloat(3),
        maxFactor: CGFloat(2)),
      header: (
        fadingPercentage: CGFloat(0.2),
        defaultAlpha: CGFloat(1)),
      titleShowingPercentage: CGFloat(0.8))
    static let titleLabel = (
      font: Font.bold(15),
      textColor: UIColor.gray)
    static let titleView = (
      title: (
        font: Font.regular(15),
        textColor: UIColor.red), subtitle: (
        font: Font.regular(12),
        textColor: UIColor.lightGray),
      height: CGFloat(36))
    static let reloadAnimationDuration: TimeInterval = 0.6
    static let offsetToHideTitle: CGFloat = 40
    static let heightAnimationDuration: TimeInterval = 0.25
  }

  // MARK: - Properties

  private let headerViewController: HeaderViewController
  private var contentViewController: ContentViewController
  private let presentationCenter: OverlayPresentationCenterProtocol?

  private let headerContainer = UIView()
  private let contentDecoratorView = UIView()
  private var headerContainerHeightConstraint: NSLayoutConstraint?
  private var decorationViewBottomConstraint: NSLayoutConstraint?

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = Constants.titleLabel.font
    label.textColor = Constants.titleLabel.textColor
    label.text = contentViewController.title
    return label
  }()

  private lazy var titleViewTitleLabel: UILabel = {
    let constants = Constants.titleView.title
    let title = UILabel()
    title.font = constants.font
    title.textColor = constants.textColor
    title.textAlignment = .center
    return title
  }()

  private lazy var titleViewSubtitleLabel: UILabel = {
    let constants = Constants.titleView.subtitle
    let subtitle = UILabel()
    subtitle.font = constants.font
    subtitle.textColor = constants.textColor
    subtitle.textAlignment = .center
    return subtitle
  }()

  private lazy var titleView: UIView = {
    let stackView = UIStackView(arrangedSubviews: [titleViewTitleLabel, titleViewSubtitleLabel])
    stackView.distribution = .equalCentering
    stackView.axis = .vertical
    stackView.alignment = .center
    return stackView
  }()

  private var contentTopInset: CGFloat {
    contentViewController.contentTopInset
  }

  private var contentVerticalOffset: CGFloat {
    contentViewController.verticalOffset
  }

  // MARK: - Configuration

  private func configureHeaderContainer() {
    headerContainer.backgroundColor = .clear
    headerContainer.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(headerContainer)
    let heightConstraint = headerContainer.heightAnchor.constraint(equalToConstant: .zero)
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: headerContainer.topAnchor),
      view.leftAnchor.constraint(equalTo: headerContainer.leftAnchor),
      view.rightAnchor.constraint(equalTo: headerContainer.rightAnchor),
      heightConstraint,
    ])
    headerContainerHeightConstraint = heightConstraint
  }

  private func configureHeaderViewController() {
    embedChild(headerViewController, to: headerContainer)
    headerViewController.delegate = self
  }

  private func configureContentDecoratorView() {
    let constants = Constants.contentDecoratorView
    contentDecoratorView.translatesAutoresizingMaskIntoConstraints = false
    contentDecoratorView.backgroundColor = constants.backgroundColor
    view.addSubview(contentDecoratorView)
    let bottomConstraint = contentDecoratorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    NSLayoutConstraint.activate([
      view.leftAnchor.constraint(equalTo: contentDecoratorView.leftAnchor),
      view.rightAnchor.constraint(equalTo: contentDecoratorView.rightAnchor),
      headerContainer.bottomAnchor.constraint(equalTo: contentDecoratorView.topAnchor),
      bottomConstraint,
    ])
    decorationViewBottomConstraint = bottomConstraint
    contentDecoratorView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    contentDecoratorView.layer.cornerRadius = Constants.contentDecoratorView.cornerRadius
  }

  // MARK: - Update

  private func updateForContentViewHeight(_ view: FadingInfoContentViewProtocol) {
    let shouldShowDecoratorView = view.shouldShowDecoratorView
    let radius: CGFloat = shouldShowDecoratorView ? Constants.contentDecoratorView.cornerRadius : .zero
    contentDecoratorView.isHidden = !shouldShowDecoratorView
    view.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: radius)
  }

  private func updateHeaderContainerHeight(with contentHeight: CGFloat, animate: Bool) {
    let minimalHeaderContainerHeight = view.frame.height - contentViewController.minimalHeight
    let headerContainerHeight = min(contentHeight, minimalHeaderContainerHeight)

    headerContainerHeightConstraint?.constant = headerContainerHeight
    decorationViewBottomConstraint?.constant = headerContainerHeight

    let block: () -> Void = { [weak self] in
      guard let self = self else { return }
      self.contentViewController.contentTopInset = headerContainerHeight
      self.view.setNeedsLayout()
    }
    if animate {
      UIView.animate(withDuration: Constants.heightAnimationDuration, animations: block)
    } else {
      block()
    }
  }

  private func updateContainerTransition() {
    let constants = Constants.transition
    let progress = contentDecoratorView.isHidden
      ? .zero
      : (contentTopInset + contentVerticalOffset) / headerContainer.frame.height
    let percentage = clamp(.zero, progress, 1)
    let contentViewNeedsTitle = percentage > constants.titleShowingPercentage
    let headerViewNeedsTitle = headerViewController.verticalOffset > Constants.offsetToHideTitle
    updateNavigationItemTitle(isHidden: !(contentViewNeedsTitle || headerViewNeedsTitle))
    headerViewController.view.alpha = constants.header.defaultAlpha * clamp(.zero, (1 - percentage) / (1 - constants.header.fadingPercentage), 1)
    headerViewController.shadowsFactor = clamp(.zero, 1 - (progress * constants.shadow.fadingSpeed), constants.shadow.maxFactor)
  }

  private func updateContentDecoratorViewPosition() {
    let offset = contentTopInset + contentVerticalOffset
    let translationY = max(-headerContainer.frame.height, -offset)
    contentDecoratorView.transform = .init(translationX: 0, y: translationY)
  }

  private func updateDecoratorViewShadow() {
    let shadow = Constants.contentDecoratorView.shadow
    contentDecoratorView.layer.apply(shadow: CALayer.Shadow(
      color: shadow.color,
      opacity: shadow.opacity,
      offset: shadow.offset,
      radius: shadow.radius)
    )
  }

  private func updateNavigationItemTitle(isHidden: Bool) {
    navigationItem.titleView = isHidden ? titleLabel : titleView
    updateTitleView(title: headerViewController.screenTitle, subtitle: headerViewController.screenSubtitle)
  }

  private func updateTitleView(title: String?, subtitle: String?) {
    titleViewTitleLabel.text = title
    titleViewSubtitleLabel.text = subtitle

    titleViewTitleLabel.sizeToFit()
    titleViewSubtitleLabel.sizeToFit()

    let width = max(titleViewTitleLabel.frame.size.width, titleViewSubtitleLabel.frame.size.width)
    titleView.frame = CGRect(x: .zero, y: .zero, width: width, height: Constants.titleView.height)
  }
}

// MARK: FadingInfoContentViewDelegate

extension FadingInfoViewController: FadingInfoContentViewDelegate {
  public func fadingInfoContentViewDidRequestShowFailure(_: FadingInfoContentViewProtocol) {
    headerViewController.showError()
  }

  public func fadingInfoContentViewDidUpdateVerticalOffset(_: FadingInfoContentViewProtocol) {
    updateContainerTransition()
    updateContentDecoratorViewPosition()
  }

  public func fadingInfoContentViewDidUpdateContentHeight(_ view: FadingInfoContentViewProtocol) {
    updateForContentViewHeight(view)
    updateHeaderContainerHeight(with: headerViewController.contentHeight, animate: false)
  }

  public func fadingInfoContentView(_: FadingInfoContentViewProtocol, didRequestAnimateReloadWith view: UIView) {
    let transformY = contentViewController.view.frame.height
    let views: [UIView] = [contentDecoratorView, view]
    views.forEach { $0.transform = CGAffineTransform(translationX: .zero, y: transformY) }
    UIView.animate(withDuration: Constants.reloadAnimationDuration, animations: {
      views.forEach { $0.transform = .identity }
    })
  }
}

// MARK: FadingInfoHeaderViewDelegate

extension FadingInfoViewController: FadingInfoHeaderViewDelegate {
  public var containerHeight: CGFloat {
    view.bounds.height
  }

  public func fadingInfoHeaderViewDidUpdateContentHeight(_ view: FadingInfoHeaderViewProtocol, animate: Bool) {
    updateHeaderContainerHeight(with: view.contentHeight, animate: animate)
    updateContainerTransition()
    updateContentDecoratorViewPosition()
  }

  public func fadingInfoHeaderViewDidRequestShowEmbeddedInBottomSheet(_ viewController: UIViewController) {
    guard
      let presentationCenter = presentationCenter,
      let viewController = viewController as? OldBottomSheetChildProtocol else { return }
    let containerVc = OldBottomSheetContainerViewController(topController: viewController)
    containerVc.topArrowType = .arrow
    containerVc.modalPresentationStyle = .overCurrentContext
    presentationCenter.presentViewController(containerVc, animated: false)
  }

  public func fadingInfoHeaderViewDidRequestShowEmbeddedInBaseSliding(_ viewController: ChildViewControllerDelegate, contentHeight: CGFloat) {
    guard let presentationCenter = presentationCenter else { return }
    let container = BaseSlidingViewController(topViewController: viewController)
    container.topPadding = max(.zero, UIScreen.main.bounds.height - contentHeight - BaseSlidingViewController.topArrowHeight - view.safeAreaInsets.bottom)
    presentationCenter.presentViewController(container, animated: false)
  }

  public func fadingInfoHeaderViewDidUpdateVerticalOffset(_: FadingInfoHeaderViewProtocol) {
    updateContainerTransition()
    updateContentDecoratorViewPosition()
  }
}

// MARK: FadingInfoViewDelegate

extension FadingInfoViewController: FadingInfoViewDelegate {
  func fadingInfoView(_: FadingInfoView, hitTest point: CGPoint, with event: UIEvent?) -> UIView? {
    point.y < contentDecoratorView.frame.minY
      ? headerViewController.view.hitTest(point, with: event)
      : contentViewController.view.hitTest(point, with: event)
  }
}

// MARK: - FadingInfoHeaderViewDelegate

public protocol FadingInfoHeaderViewDelegate: AnyObject {
  func fadingInfoHeaderViewDidRequestShowEmbeddedInBottomSheet(_ viewController: UIViewController)
  func fadingInfoHeaderViewDidRequestShowEmbeddedInBaseSliding(_ viewController: ChildViewControllerDelegate, contentHeight: CGFloat)
  func fadingInfoHeaderViewDidUpdateContentHeight(_ view: FadingInfoHeaderViewProtocol, animate: Bool)
  func fadingInfoHeaderViewDidUpdateVerticalOffset(_ view: FadingInfoHeaderViewProtocol)
  var containerHeight: CGFloat { get }
}

// MARK: - FadingInfoHeaderViewProtocol

public protocol FadingInfoHeaderViewProtocol: AnyObject {
  var delegate: FadingInfoHeaderViewDelegate? { get set }
  var contentHeight: CGFloat { get }
  var verticalOffset: CGFloat { get }
  var shadowsFactor: CGFloat { get set }
  var screenTitle: String? { get }
  var screenSubtitle: String? { get }

  func showError()
}

extension FadingInfoHeaderViewProtocol {
  public func showError() {}
}

// MARK: - FadingInfoViewDelegate

protocol FadingInfoViewDelegate: AnyObject {
  func fadingInfoView(_ view: FadingInfoView, hitTest point: CGPoint, with event: UIEvent?) -> UIView?
}

// MARK: - FadingInfoView

final class FadingInfoView: UIView {

  // MARK: Public

  override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    delegate?.fadingInfoView(self, hitTest: point, with: event)
  }

  // MARK: Internal

  weak var delegate: FadingInfoViewDelegate?
}

// MARK: - FadingInfoContentViewDelegate

public protocol FadingInfoContentViewDelegate: AnyObject {
  func fadingInfoContentViewDidRequestShowFailure(_ view: FadingInfoContentViewProtocol)
  func fadingInfoContentViewDidUpdateVerticalOffset(_ view: FadingInfoContentViewProtocol)
  func fadingInfoContentViewDidUpdateContentHeight(_ view: FadingInfoContentViewProtocol)
  func fadingInfoContentView(_ contentView: FadingInfoContentViewProtocol, didRequestAnimateReloadWith view: UIView)
}

// MARK: - FadingInfoContentViewProtocol

public protocol FadingInfoContentViewProtocol: AnyObject {
  var viewDelegate: FadingInfoContentViewDelegate? { get set }
  var contentTopInset: CGFloat { get set }
  var contentHeight: CGFloat { get }
  var verticalOffset: CGFloat { get }
  var minimalHeight: CGFloat { get }
  var shouldShowDecoratorView: Bool { get }

  func roundCorners(_ corners: CACornerMask, radius: CGFloat)
}

extension UIViewController {
  public func embedChild(_ viewController: UIViewController, to container: UIView? = nil) {
    addChild(viewController)
    let containerView: UIView = container ?? view
    let childView: UIView = viewController.view
    childView.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(childView)
    NSLayoutConstraint.activate([
      childView.topAnchor.constraint(equalTo: containerView.topAnchor),
      childView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
      childView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
      childView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
    ])
    viewController.didMove(toParent: self)
  }

  public func unembedFromParentIfNeeded() {
    guard parent != nil else { return }
    willMove(toParent: nil)
    removeFromParent()
    view.removeFromSuperview()
  }
}

public func clamp<T: Comparable>(_ left: T, _ value: T, _ right: T) -> T {
  if value < left { return left }
  if value > right { return right }
  return value
}

// MARK: - OldBottomSheetChildProtocol

public protocol OldBottomSheetChildProtocol where Self: UIViewController {
  var bottomSheetDelegate: OldBottomSheetParentProtocol? { get set }

  func topPadding() -> CGFloat
  func scrollView() -> UIScrollView
  func didDismiss()
}

extension OldBottomSheetChildProtocol {
  public func dismiss(animated: Bool, completionHandler: (() -> Void)?) {
    if let parent = bottomSheetDelegate {
      return parent.dismiss(animated: animated, completionHandler: completionHandler)
    }
    dismiss(animated: animated, completion: completionHandler)
  }
}

// MARK: - OldBottomSheetParentProtocol

public protocol OldBottomSheetParentProtocol: AnyObject {
  func bottomSheetScrollViewDidScroll(_ scrollView: UIScrollView)
  func dismiss(animated: Bool, completionHandler: (() -> Void)?)
  func contentSizeUpdated()
}

extension OldBottomSheetParentProtocol {
  public func dismiss(animated: Bool) {
    dismiss(animated: animated, completionHandler: nil)
  }
}

// MARK: - ProductContainerState

public enum ProductContainerState {
  case close, middle, open
}

// MARK: - BottomSheetTopArrowView

public enum BottomSheetTopArrowView: Int {
  case empty, arrow
}

// MARK: - OldBottomSheetContainerViewController

public class OldBottomSheetContainerViewController: UIViewController, OverlayPresentable {

  // MARK: Lifecycle

  public convenience init(viewController: UIViewController) {
    self.init(topController: viewController as! OldBottomSheetChildProtocol) // swiftlint:disable:this force_cast
  }

  public init(topController: OldBottomSheetChildProtocol) {
    self.topController = topController
    super.init(nibName: nil, bundle: nil)
    providesPresentationContextTransitionStyle = true
    definesPresentationContext = true
    modalPresentationStyle = .overCurrentContext

    topController.bottomSheetDelegate = self
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public weak var presentableDelegate: OverlayPresentableDelegate?

  public let kVelocityTreshold: CGFloat = 20
  public let kMinYOffset: CGFloat = -0.001
  public let kMinTopPadding: CGFloat = 28.0
  public var threshold: CGFloat = 0

  public var topPadding: CGFloat = 0
  public var bluredView: UIVisualEffectView! // swiftlint:disable all
  public var topView: UIScrollView!
  public var arrowView: UIView!
  public var topController: OldBottomSheetChildProtocol
  public var panGestureRecognizer: UIPanGestureRecognizer?
  public var isCanMove: Bool = false
  public var topArrowType: BottomSheetTopArrowView = .empty

  public var scrollView: UIScrollView? {
    didSet {
      guard let scrollView = scrollView else { return }
      scrollView.panGestureRecognizer.addTarget(self, action: #selector(childPanned(recognizer:)))
      //            scrollView.isScrollEnabled = false
    }
  }

  public var state: ProductContainerState = .close {
    didSet {
      guard let scrollView = scrollView else { return }
      scrollView.bounces = state == .open ? true : false
    }
  }

  override public func viewDidLoad() {
    super.viewDidLoad()

    setup()
  }

  override public func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    prepareBackgroundView()
    show()
  }

  public func prepareBackgroundView() {
    if bluredView == nil {
      let blurEffect = UIBlurEffect(style: .dark)
      let visualEffect = UIVisualEffectView(effect: blurEffect)
      bluredView = UIVisualEffectView(effect: blurEffect)
      bluredView.contentView.addSubview(visualEffect)
      visualEffect.frame = view.bounds
      bluredView.frame = view.bounds
      bluredView.alpha = 0.0
      visualEffect.alpha = 0.0
      bluredView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
      view.insertSubview(bluredView, belowSubview: topView)
    }
  }

  @objc
  public func tapped() {
    dismiss(animated: true, completionHandler: nil)
  }

  public func isOpen() -> Bool {
    topView.frame.origin.y == minTopPadding()
  }

  public func minTopPadding() -> CGFloat {
    let window = UIApplication.shared.asKeyWindow
    return max(window?.safeAreaInsets.top ?? 0, kMinTopPadding)
  }

  // MARK: Private

  private func show() {
    scrollView = topController.scrollView()
    topController.view.frame.size.width = UIScreen.main.bounds.width
    topPadding = updateTopPadding()
    threshold = topPadding
    topView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height - topPadding)
    topController.view.frame = CGRect(
      x: 0,
      y: arrowView.frame.origin.y + arrowView.bounds.height,
      width: topView.bounds.width,
      height: topView.bounds.height - arrowView.frame.origin.y - arrowView.bounds.height)
    // Сначала прячем контейнер вниз экрана
    topView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.size.width, height: topView.bounds.height)
    animate()
  }

  private func animate() {
    let frame = CGRect(x: 0, y: topPadding, width: topView.bounds.width, height: view.bounds.size.height - topPadding)
    UIView.animate(withDuration: 0.35, animations: {
      self.topView.frame = frame
      self.bluredView.alpha = 1.0
    }) { _ in
      self.state = self.isOpen() ? .open : .middle
    }
  }

  private func setup() {
    view.backgroundColor = .clear

    arrowView = topArrowView()
    topView = UIScrollView(frame: .zero)
    topView.bounces = false
    topView.autoresizingMask = [.flexibleBottomMargin, .flexibleWidth]
    topView.backgroundColor = topController.view.backgroundColor

    topView.layer.cornerRadius = 14.0
    topView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    topView.layer.masksToBounds = true
    topView.addSubview(arrowView)

    view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    view.addSubview(topView)
    view.bringSubviewToFront(topView)

    addChild(topController)

    topView.addSubview(topController.view)
    topController.didMove(toParent: self)

    panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned(recognizer:)))
    panGestureRecognizer?.delegate = self
    topView.addGestureRecognizer(panGestureRecognizer!)
  }

  private func topArrowView() -> UIView {
    switch topArrowType {
    case .arrow:
      let arrowImage = UIImage(named: "closeDrawer")
      let arrowView = UIImageView(image: arrowImage)
      arrowView.frame = CGRect(x: (view.bounds.width - arrowView.bounds.width) / 2.0, y: 16, width: arrowView.bounds.width, height: arrowView.bounds.height)

      let arrowHolderView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: arrowView.frame.origin.y + arrowView.bounds.height + 4.0))
      arrowHolderView.backgroundColor = .clear
      arrowHolderView.addSubview(arrowView)
      arrowHolderView.isUserInteractionEnabled = true
      arrowHolderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))

      return arrowHolderView
    default:
      return UIView(frame: .zero)
    }
  }

  private func updateTopPadding() -> CGFloat {
    let window = UIApplication.shared.asKeyWindow
    let topSafeAreaPadding = max(window?.safeAreaInsets.top ?? 0, kMinTopPadding)
    let bottomSafeAreaPadding = window?.safeAreaInsets.bottom ?? 0

    return max(topSafeAreaPadding, topController.topPadding() - bottomSafeAreaPadding - arrowView.frame.height)
  }
}

// MARK: UIGestureRecognizerDelegate

extension OldBottomSheetContainerViewController: UIGestureRecognizerDelegate {

  // MARK: Public

  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    let velocity = (gestureRecognizer as! UIPanGestureRecognizer).velocity(in: topView) // swiftlint:disable:this force_cast
    return abs(velocity.y) > abs(velocity.x)
  }

  public func gestureRecognizer(
    _: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer)
    -> Bool
  {
    true
  }

  @objc
  public func childPanned(recognizer: UIPanGestureRecognizer) {
    manage(gestureRecognizer: recognizer)
  }

  @objc
  public func panned(recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translation(in: topView)
    let velocity = recognizer.velocity(in: topView)
    let frameY = topView.frame.origin.y + translation.y
    manage(gestureRecognizer: recognizer)

    let newTopPadding = updateTopPadding()
    // Если они не равны, то вью можно поднять, либо опустить
    if newTopPadding != topPadding {
      topPadding = newTopPadding
    }

    if topView.frame.origin.y > topPadding {
      topView.frame = CGRect(x: 0, y: max(newTopPadding, frameY), width: view.bounds.size.width, height: view.bounds.size.height - max(newTopPadding, frameY))
      let height = view.bounds.height
      let percentage = (frameY - threshold) / height
      bluredView.alpha = fmax(1.0 - percentage, 0)
    } else {
      // Мы уперлись в верх и движемся наврех (высталяем по toppading)
      if velocity.y < 0 {
        topView.frame = CGRect(x: 0, y: topPadding, width: view.bounds.size.width, height: view.bounds.size.height - topPadding)
      } else if scrollView!.contentOffset.y == 0 {
        topView.frame = CGRect(x: 0, y: max(newTopPadding, frameY), width: view.bounds.size.width, height: view.bounds.size.height - max(newTopPadding, frameY))
        let height = view.bounds.height
        let percentage = (frameY - threshold) / height
        bluredView.alpha = fmax(1.0 - percentage, 0)
      }
      if state == .open, scrollView!.contentOffset.y >= 0 {
        // Мы находимся в верхней точки и продолжаем скроллить вверх, нужно подрубить скролл таблицы
        scrollView!.setContentOffset(CGPoint(x: scrollView!.contentOffset.x, y: scrollView!.contentOffset.y - translation.y), animated: false)
      }
    }
    recognizer.setTranslation(CGPoint.zero, in: view)
    state = isOpen() ? .open : .middle

    if recognizer.state == .ended {
      if velocity.y > kVelocityTreshold, scrollView!.contentOffset.y <= CGFloat(0.0) {
        dismiss(animated: true, completionHandler: nil)
      } else if frameY > topPadding, scrollView!.contentOffset.y <= CGFloat(0.0) {
        showAnimation()
      }
      if state == .open {
        if (scrollView!.contentOffset.y + topView.bounds.height) > scrollView!.contentSize.height {
          scrollView!.setContentOffset(CGPoint(x: scrollView!.contentOffset.x, y: scrollView!.contentSize.height - scrollView!.bounds.height), animated: true)
        } else if velocity.y < 0 {
          let y = min(scrollView!.contentOffset.y - velocity.y / 5, scrollView!.contentSize.height - scrollView!.bounds.height)
          scrollView!.setContentOffset(CGPoint(x: scrollView!.contentOffset.x, y: y), animated: true)
        }
      }
    }
  }

  // MARK: Private

  private func showAnimation() {
    let frame = CGRect(x: 0, y: topPadding, width: topView.bounds.width, height: view.bounds.size.height - topPadding)
    UIView.animate(withDuration: 0.35, delay: 0.0, options: .beginFromCurrentState, animations: {
      self.topView.frame = frame
      self.bluredView.alpha = 1.0
      self.topView.layoutIfNeeded()
    }) { _ in
      self.state = self.isOpen() ? .open : .middle
    }
  }

  private func manage(gestureRecognizer: UIPanGestureRecognizer) {
    let direction = gestureRecognizer.velocity(in: view).y
    state = isOpen() ? .open : .middle
    switch state {
    case .middle:
      scrollView?.isScrollEnabled = false
    case .open:
      if direction < 0 {
        scrollView?.isScrollEnabled = true
      } else if direction >= 0, scrollView!.contentOffset.y > 0.0 {
        scrollView?.isScrollEnabled = true
      } else {
        scrollView?.isScrollEnabled = false
      }
    default:
      scrollView?.isScrollEnabled = false
    }
    //        panGestureRecognizer?.isEnabled = !scrollView!.isScrollEnabled
  }
}

// MARK: OldBottomSheetParentProtocol

extension OldBottomSheetContainerViewController: OldBottomSheetParentProtocol {
  public func bottomSheetScrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y <= 0 {
      scrollView.contentOffset.y = kMinYOffset
    }
  }

  public func dismiss(animated _: Bool, completionHandler: (() -> Void)?) {
    let height = view.bounds.height - topView.frame.origin.y
    let frame = topView.frame.offsetBy(dx: 0, dy: height)

    UIView.animate(withDuration: 0.35, animations: {
      self.topView.frame = frame
      self.bluredView.alpha = 0
    }) { _ in
      super.dismiss(animated: false, completion: completionHandler)
      self.topController.didDismiss()
      self.presentableDelegate?.overlayPresentableDidDismiss(self)
    }
  }

  public func contentSizeUpdated() {
    guard state != .close else { return }
    topPadding = updateTopPadding()
    threshold = topPadding
    animate()
  }
}

// MARK: - ChildViewControllerDelegate

public protocol ChildViewControllerDelegate: NSObjectProtocol {
  var topPadding: CGFloat { get }
  func slidingViewControllerWillDismiss()
  func viewDidAppearWithAnimation()
}

// MARK: - BaseSlidingViewController

open class BaseSlidingViewController: UIViewController, OverlayPresentable {

  // MARK: Lifecycle

  public init(topViewController: ChildViewControllerDelegate) {
    super.init(nibName: nil, bundle: nil)

    //        assert(topViewController is ChildViewControllerDelegate, "topViewController has to conforms ChildViewControllerDelegate")

    isKeyboardAffectsTopPadding = true

    if topViewController.topPadding > 0 {
      topPadding = topViewController.topPadding
    } else {
      topPadding = kMinTopPadding
    }

    if let topViewController = topViewController as? UIViewController {
      self.topViewController = topViewController
    } else {
      assert(false, "topViewController has to conforms ChildViewControllerDelegate")
    }

    providesPresentationContextTransitionStyle = true
    definesPresentationContext = true
    modalPresentationStyle = .overCurrentContext
  }

  public convenience init?(topViewController: ChildViewControllerDelegate, keyboardAffectsTopPadding keyboardAffects: Bool) {
    self.init(topViewController: topViewController)
    isKeyboardAffectsTopPadding = keyboardAffects
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: Open

  override open func viewDidLoad() {
    super.viewDidLoad()

    setup()

    hideTopViewController()
  }

  override open func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if isKeyboardAffectsTopPadding {
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    showTopViewControllerAnimated()
  }

  override open func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    view.resignFirstResponder()
    if isKeyboardAffectsTopPadding {
      NotificationCenter.default.removeObserver(self)
    }
  }

  override open func dismiss(animated _: Bool, completion: (() -> Void)? = nil) {
    let height: CGFloat = view.frame.size.height - topView!.frame.origin.y
    let frame: CGRect = topView!.frame.offsetBy(dx: 0, dy: height)

    if let topViewController = topViewController as? ChildViewControllerDelegate {
      topViewController.slidingViewControllerWillDismiss()
    }

    UIView.animate(withDuration: 0.35, animations: {
      self.topView!.frame = frame
      self.shadowView?.alpha = 0
    }) { _ in
      self.presentableDelegate?.overlayPresentableDidDismiss(self)
      super.dismiss(animated: false, completion: completion)
    }
  }

  // MARK: Public

  public static let topArrowHeight: CGFloat = 31.0

  public weak var presentableDelegate: OverlayPresentableDelegate?

  @objc public var topPadding: CGFloat = 0.0

  public func present(
    topViewController: ChildViewControllerDelegate,
    topPadding: CGFloat)
  {
    let height: CGFloat = view.frame.size.height - topView!.frame.origin.y
    let frame: CGRect = topView!.frame.offsetBy(dx: 0, dy: height)

    UIView.animate(withDuration: 0.35, animations: {
      self.topView!.frame = frame
    }) { _ in
      self.topViewController?.removeFromParent()

      self.topPadding = topPadding
      self.topViewController = topViewController as? UIViewController

      self.setup()

      let height = self.topView!.frame.height
      self.topView!.frame = self.topView!.frame.offsetBy(
        dx: .zero,
        dy: height)

      self.showTopViewControllerAnimated()
    }
  }

  // MARK: Internal

  func setup() {
    view.backgroundColor = .clear

    let arrowHolderView: UIView = getTopArrowView()
    //        if topPadding - kMinTopPadding > arrowHolderView.sizeHeight {
    topPadding -= arrowHolderView.frame.origin.y * 2.0 + arrowHolderView.frame.size.height
    //        }
    originalTopPadding = topPadding

    var frame = CGRect(x: view.bounds.origin.x, y: view.bounds.origin.y + topPadding, width: view.bounds.size.width, height: view.bounds.size.height - topPadding)

    topView = UIView(frame: frame)
    topView?.autoresizingMask = [.flexibleBottomMargin, .flexibleWidth]
    topView?.backgroundColor = topViewController!.view.backgroundColor
    topView?.layer.cornerRadius = 10
    topView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    topView?.layer.masksToBounds = true
    topView!.addSubview(arrowHolderView)

    frame = topView!.bounds
    frame.origin.y += arrowHolderView.frame.origin.y * 2.0 + arrowHolderView.frame.size.height
    frame.size.height -= arrowHolderView.frame.origin.y * 2.0 + arrowHolderView.frame.size.height

    view.autoresizingMask = [.flexibleHeight, .flexibleWidth]

    view.addSubview(topView!)
    view.bringSubviewToFront(topView!)

    addChild(topViewController!)
    topViewController!.view.frame = frame
    topView!.addSubview(topViewController!.view)
    topViewController!.didMove(toParent: self)
  }

  func getTopArrowView() -> UIView {
    let arrowView = UIImageView( /* image: UIImage(named: "closeDrawer") */ )
    arrowView.frame.origin.x = (view.bounds.size.width - arrowView.frame.size.width) / 2.0
    arrowView.frame.origin.y = 16

    let arrowHolderView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: arrowView.frame.origin.y + arrowView.frame.size.height + 4.0))
    arrowHolderView.addSubview(arrowView)

    arrowHolderView.isUserInteractionEnabled = true
    arrowHolderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned))
    panGestureRecognizer.delegate = self
    arrowHolderView.addGestureRecognizer(panGestureRecognizer)
    return arrowHolderView
  }

  func addBottomShadow() {
    if shadowView == nil {
      let blurEffect = UIBlurEffect(style: .dark)
      shadowView = UIVisualEffectView(effect: blurEffect)
      shadowView!.frame = view.frame
      shadowView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      shadowView!.isUserInteractionEnabled = true
      shadowView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }
    shadowView!.alpha = 0
    view.insertSubview(shadowView!, belowSubview: topView!)
  }

  func removeBottomShadow() {
    shadowView?.removeFromSuperview()
  }

  func showTopViewControllerAnimated() {
    let height: CGFloat = topView!.frame.origin.y - topPadding
    let frame: CGRect = topView!.frame.offsetBy(dx: 0, dy: -height)
    UIView.animate(withDuration: 0.35, animations: {
      self.topView!.frame = frame
      self.shadowView?.alpha = 1
    }) { _ in
      if let topViewController = self.topViewController as? ChildViewControllerDelegate {
        topViewController.viewDidAppearWithAnimation()
      }
    }
  }

  func hideTopViewController() {
    addBottomShadow()

    let height = topView!.frame.height //
    topView!.frame = topView!.frame.offsetBy(dx: 0, dy: height)
  }

  @objc
  func tapped(_: UITapGestureRecognizer?) {
    dismiss(animated: false)
  }

  @objc
  func panned(_ recognizer: UIPanGestureRecognizer) {
    let translation: CGPoint = recognizer.translation(in: topView)
    let velocity: CGPoint = recognizer.velocity(in: topView)
    let frameY: CGFloat = topView!.frame.origin.y + translation.y
    if frameY >= topPadding {
      topView!.center = CGPoint(x: topView!.center.x, y: topView!.center.y + translation.y)

      let height = view.frame.size.height
      let percentage: CGFloat = (frameY - topPadding) / height
      shadowView?.alpha = CGFloat(fmax(Float(1.0 - percentage), 0))
    }

    if recognizer.state == .ended {
      if velocity.y > 0 {
        dismiss(animated: true)
      } else if frameY > topPadding {
        showTopViewControllerAnimated()
      }
    }

    recognizer.setTranslation(CGPoint(x: 0, y: 0), in: view)
  }

  @objc
  func keyboardWillShow(notification: Notification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      topPadding = originalTopPadding - keyboardSize.height
      showTopViewControllerAnimated()
    }
  }

  @objc
  func keyboardWillHide(notification: Notification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      topPadding = originalTopPadding + keyboardSize.height
      showTopViewControllerAnimated()
    }
  }

  // MARK: Private

  private let kMinTopPadding: CGFloat = 98.0

  private var topViewController: UIViewController?
  private var topView: UIView?
  private var shadowView: UIView?
  private var originalTopPadding: CGFloat = 0.0
  private var isKeyboardAffectsTopPadding = false
}

// MARK: UIGestureRecognizerDelegate

extension BaseSlidingViewController: UIGestureRecognizerDelegate {
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    let velocity: CGPoint = (gestureRecognizer as! UIPanGestureRecognizer).velocity(in: topView) // swiftlint:disable:this force_cast
    return abs(Float(velocity.y)) > abs(Float(velocity.x))
  }
}
// swiftlint:disable all
