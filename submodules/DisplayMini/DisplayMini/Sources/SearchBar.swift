//
//  SearchBar.swift
//  Display
//
//  Created by Алексей Смирнов on 29.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import EpoxyCore
import UIKit

// MARK: - SearchBar

public final class SearchBar: UIView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    directionalLayoutMargins = .zero
    addSubview(searchBar)
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.constrainToMarginsWithHighPriorityBottom()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public struct Style: Hashable {
    public init() {

    }
  }

  public struct Content: Equatable {
    public init() {

    }
  }

  public struct Behaviors {
    public var didTapCancel: (() -> Void)?
    public var didEnterSearchText: ((String) -> Void)?

    public init(didTapCancel: (() -> Void)?, didEnterSearchText: ((String) -> Void)?) {
      self.didTapCancel = didTapCancel
      self.didEnterSearchText = didEnterSearchText
    }
  }

  public private(set) lazy var searchBar: UISearchBar = {
    $0.backgroundColor = .clear
    $0.delegate = self
    $0.searchBarStyle = .minimal
    $0.showsCancelButton = true
    $0.backgroundImage = UIImage()
    $0.tintColor = .accent
    $0.autocapitalizationType = .none
    $0.searchTextField.layer.cornerRadius = 20
    $0.searchTextField.layer.masksToBounds = true
    $0.searchTextField.layer.cornerCurve = .continuous
    return $0
  }(UISearchBar())

  public func setBehaviors(_ behaviors: Behaviors?) {
    didTapCancel = behaviors?.didTapCancel
    didEnterSearchText = behaviors?.didEnterSearchText
  }

  public func setContent(_ content: Content, animated: Bool) {

  }

  // MARK: Private

  private var didTapCancel: (() -> Void)?
  private var didEnterSearchText: ((String) -> Void)?

  private let style: Style
}

// MARK: UISearchBarDelegate

extension SearchBar: UISearchBarDelegate {
  public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    didTapCancel?()
  }

  public func searchBar(
    _: UISearchBar,
    textDidChange searchText: String)
  {
    didEnterSearchText?(searchText)
  }
}
