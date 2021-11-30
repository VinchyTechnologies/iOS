//
//  TopTabBarView.swift
//  Display
//
//  Created by Алексей Смирнов on 04.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Epoxy

// MARK: - TopTabBarView

public final class TopTabBarView: UIView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    super.init(frame: .zero)
    backgroundColor = .mainBackground
    translatesAutoresizingMaskIntoConstraints = false
    directionalLayoutMargins = .zero
    addSubview(tabView)
    tabView.translatesAutoresizingMaskIntoConstraints = false
    tabView.constrainToMarginsWithHighPriorityBottom()
    tabView.heightAnchor.constraint(equalToConstant: 56).isActive = true
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public struct Style: Hashable {
    public init() {
    }
  }

  public struct Behaviors {
    var didSelect: ((Int) -> Void)?

    public init(didSelect: ((Int) -> Void)?) {
      self.didSelect = didSelect
    }
  }

  public typealias Content = TabViewModel

  public var scrollPercentage: CGFloat = 0.0 {
    didSet {
      tabView.selectItem(atIndex: Int(scrollPercentage), animated: true)
    }
  }

  public func setBehaviors(_ behaviors: Behaviors?) {
    didSelect = behaviors?.didSelect
  }

  public func setContent(_ content: Content, animated: Bool) {
    tabView.configure(with: content)
  }

  // MARK: Private

  private var didSelect: ((Int) -> Void)?

  private lazy var tabView: TabView = {
    $0.delegate = self
    return $0
  }(TabView())

}

// MARK: TabViewDelegate

extension TopTabBarView: TabViewDelegate {
  public func tabView(
    _ view: TabView,
    didSelect item: TabItemViewModel,
    atIndex index: Int)
  {
    didSelect?(index)
  }
}
