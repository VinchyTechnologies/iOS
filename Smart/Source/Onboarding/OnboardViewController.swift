//
//  OnboardViewController.swift
//  OnboardKit
//

import UIKit

// MARK: - OnboardingViewControllerOutput

protocol OnboardingViewControllerOutput: AnyObject {
  func didFinishWathingOnboarding()
}

// MARK: - OnboardViewController

public final class OnboardViewController: UIViewController {

  // MARK: Lifecycle

  // MARK: - Initializers

  public init(
    pageItems: [OnboardPage],
    appearanceConfiguration: AppearanceConfiguration = AppearanceConfiguration())
  {
    self.pageItems = pageItems
    self.appearanceConfiguration = appearanceConfiguration
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  public required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  override public func loadView() {
    view = UIView(frame: .zero)
    view.backgroundColor = appearanceConfiguration.backgroundColor
    if let pageViewControllerForFirstIndex = pageViwControllerFor(pageIndex: 0) {
      pageViewController.setViewControllers(
        [pageViewControllerForFirstIndex],
        direction: .forward,
        animated: false,
        completion: nil)
    }

    pageViewController.dataSource = self
    pageViewController.delegate = self
    pageViewController.view.frame = view.bounds

    let pageControlApperance = UIPageControl.appearance(whenContainedInInstancesOf: [OnboardViewController.self])
    pageControlApperance.pageIndicatorTintColor = appearanceConfiguration.tintColor.withAlphaComponent(0.3)
    pageControlApperance.currentPageIndicatorTintColor = appearanceConfiguration.tintColor

    addChild(pageViewController)
    view.addSubview(pageViewController.view)
    pageViewController.didMove(toParent: self)
    navigationController?.navigationBar.barTintColor = .mainBackground
  }

  // MARK: Internal

  // MARK: - Internal Properties

  weak var delegate: OnboardingViewControllerOutput?

  // MARK: Private

  // MARK: - Private Properties

  private let pageViewController = UIPageViewController(
    transitionStyle: .scroll,
    navigationOrientation: .horizontal,
    options: nil)
  private let pageItems: [OnboardPage]
  private let appearanceConfiguration: AppearanceConfiguration

  // MARK: - Private Methods

  private func pageViwControllerFor(pageIndex: Int) -> OnboardPageViewController? {
    let pageVC = OnboardPageViewController(
      pageIndex: pageIndex,
      appearanceConfiguration: appearanceConfiguration)
    guard pageIndex >= 0 else { return nil }
    guard pageIndex < pageItems.count else { return nil }
    pageVC.delegate = self
    pageVC.configureWithPage(pageItems[pageIndex])
    return pageVC
  }

  private func advanceToPageWithIndex(_ pageIndex: Int) {
    DispatchQueue.main.async { [weak self] in
      guard
        let nextPage = self?.pageViwControllerFor(pageIndex: pageIndex)
      else { return }

      self?.pageViewController.setViewControllers(
        [nextPage],
        direction: .forward,
        animated: true,
        completion: nil)
    }
  }
}

// MARK: UIPageViewControllerDataSource

extension OnboardViewController: UIPageViewControllerDataSource {
  public func pageViewController(
    _: UIPageViewController,
    viewControllerBefore viewController: UIViewController)
    -> UIViewController?
  {
    guard let pageVC = viewController as? OnboardPageViewController else { return nil }
    let pageIndex = pageVC.pageIndex
    guard pageIndex != 0 else { return nil }
    return pageViwControllerFor(pageIndex: pageIndex - 1)
  }

  public func pageViewController(
    _: UIPageViewController,
    viewControllerAfter viewController: UIViewController)
    -> UIViewController?
  {
    guard let pageVC = viewController as? OnboardPageViewController else { return nil }
    let pageIndex = pageVC.pageIndex
    return pageViwControllerFor(pageIndex: pageIndex + 1)
  }

  public func presentationCount(
    for _: UIPageViewController)
    -> Int
  {
    pageItems.count
  }

  public func presentationIndex(
    for pageViewController: UIPageViewController)
    -> Int
  {
    if let currentPage = pageViewController.viewControllers?.first as? OnboardPageViewController {
      return currentPage.pageIndex
    }
    return 0
  }
}

// MARK: UIPageViewControllerDelegate

extension OnboardViewController: UIPageViewControllerDelegate {}

// MARK: OnboardPageViewControllerDelegate

extension OnboardViewController: OnboardPageViewControllerDelegate {
  func pageViewController(
    _: OnboardPageViewController,
    actionTappedAt index: Int)
  {
    if let pageAction = pageItems[index].action {
      pageAction { success, error in
        guard error == nil else {
          return
        }

        if success {
          self.advanceToPageWithIndex(index + 1)
        }
      }
    }
  }

  func pageViewController(
    _: OnboardPageViewController,
    advanceTappedAt index: Int)
  {
    if index == pageItems.count - 1 {
      delegate?.didFinishWathingOnboarding()
    } else {
      advanceToPageWithIndex(index + 1)
    }
  }
}

// MARK: - AppearanceConfiguration

extension OnboardViewController {
  public typealias ButtonStyling = ((UIButton) -> Void)

  public struct AppearanceConfiguration {

    // MARK: Lifecycle

    public init(
      tintColor: UIColor = .accent,
      titleColor: UIColor? = nil,
      textColor: UIColor = .dark,
      backgroundColor: UIColor = .mainBackground,
      imageContentMode: UIView.ContentMode = .center,
      titleFont: UIFont = UIFont.preferredFont(forTextStyle: .title1),
      textFont: UIFont = UIFont.preferredFont(forTextStyle: .body),
      advanceButtonStyling: ButtonStyling? = nil,
      actionButtonStyling: ButtonStyling? = nil)
    {
      self.tintColor = tintColor
      self.titleColor = titleColor ?? textColor
      self.textColor = textColor
      self.backgroundColor = backgroundColor
      self.imageContentMode = imageContentMode
      self.titleFont = titleFont
      self.textFont = textFont
      self.advanceButtonStyling = advanceButtonStyling
      self.actionButtonStyling = actionButtonStyling
    }

    // MARK: Internal

    /// The color used for the page indicator and buttons
    ///
    /// - note: Defualts to the blue tint color used troughout iOS
    let tintColor: UIColor

    /// The color used for the title text
    ///
    /// - note: If not specified, defualts to whatever `textColor` is
    let titleColor: UIColor

    /// The color used for the description text (and title text `titleColor` if not set)
    ///
    /// - note: Defualts to `.darkText`
    let textColor: UIColor

    /// The color used for onboarding background
    ///
    /// - note: Defualts to white
    let backgroundColor: UIColor

    /// The `contentMode` used for the slide imageView
    ///
    /// - note: Defualts to white
    let imageContentMode: UIView.ContentMode

    /// The font used for the title and action button
    ///
    /// - note: Defualts to preferred text style `.title1` (supports dinamyc type)
    let titleFont: UIFont

    /// The font used for the desctiption label and advance button
    ///
    /// - note: Defualts to preferred text style `.body` (supports dinamyc type)
    let textFont: UIFont

    /// A Swift closure used to expose and customize the button used to advance to the next page
    ///
    /// - note: Defualts to nil. If not used, the button will be customized based on the tint and text properties
    let advanceButtonStyling: ButtonStyling?

    /// A Swift closure used to expose and customize the button used to trigger page specific action
    ///
    /// - note: Defualts to nil. If not used, the button will be customized based on the title properties
    let actionButtonStyling: ButtonStyling?
  }
}
