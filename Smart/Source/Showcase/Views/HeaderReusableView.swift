//
//  HeaderReusableView.swift
//  ASUI
//
//  Created by Aleksei Smirnov on 18.04.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - HeaderReusableViewModel

public struct HeaderReusableViewModel: ViewModelProtocol {
  fileprivate let title: String?

  public init(title: String?) {
    self.title = title
  }
}

// MARK: - HeaderReusableView

public final class HeaderReusableView: UICollectionReusableView, Reusable {

  // MARK: Lifecycle

  override public init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .mainBackground

    label.font = Font.heavy(20)
    label.textColor = .dark

    label.frame = CGRect(x: 16, y: 0, width: frame.width - 32, height: frame.height)
    addSubview(label)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Private

  private let label = UILabel()
}

// MARK: Decoratable

extension HeaderReusableView: Decoratable {
  public typealias ViewModel = HeaderReusableViewModel

  public func decorate(model: ViewModel) {
    label.text = model.title
  }
}
