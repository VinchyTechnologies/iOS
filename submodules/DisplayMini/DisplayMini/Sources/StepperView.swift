//
//  StepperView.swift
//  DisplayMini
//
//  Created by Алексей Смирнов on 15.02.2022.
//

import EpoxyCore
import UIKit

public final class StepperView: UIView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    addSubview(stepper)
    stepper.backgroundColor = .option
    stepper.translatesAutoresizingMaskIntoConstraints = false
    stepper.constrainToSuperview()
    stepper.heightAnchor.constraint(equalToConstant: 40).isActive = true
    stepper.widthAnchor.constraint(equalToConstant: 100).isActive = true
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public struct Style: Hashable {
    public init() {

    }
  }

  public typealias Content = Int

  public func setContent(_ content: Int, animated: Bool) {
    stepper.value = Double(content)
  }

  // MARK: Private

  private let stepper = Stepper()
}
