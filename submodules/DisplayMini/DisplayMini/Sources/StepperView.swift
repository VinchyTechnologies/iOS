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
    stepper.addTarget(self, action: #selector(didChangedValue), for: .valueChanged)
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
    public var didTapPlusOrMinus: (Int) -> Void
    public init(didTapPlusOrMinus: @escaping (Int) -> Void) {
      self.didTapPlusOrMinus = didTapPlusOrMinus
    }
  }
  public typealias Content = Int

  public func setBehaviors(_ behaviors: Behaviors?) {
    didTapPlusOrMinus = behaviors?.didTapPlusOrMinus
  }
  public func setContent(_ content: Int, animated: Bool) {
    stepper.value = Double(content)
  }

  // MARK: Private

  private var didTapPlusOrMinus: ((Int) -> Void)?

  private let stepper = Stepper()

  @objc
  private func didChangedValue() {
    didTapPlusOrMinus?(Int(stepper.value))
  }
}
