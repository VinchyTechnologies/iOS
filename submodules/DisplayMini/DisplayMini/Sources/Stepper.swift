//
//  Stepper.swift
//  DisplayMini
//
//  Created by Алексей Смирнов on 15.02.2022.
//

import UIKit

/**
 A stepper control provides a user interface for incrementing or decrementing a value.

 SwiftyStepper has a plus and minus button for incrementing and decrementing it's value.
 The value is displayed in the middle of the two buttons.
 */
public final class Stepper: UIControl {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }

  // MARK: Public

  /// This property enables haptic feedback when tapping on the buttons
  ///  The default value for this property is true
  public var isHapticsEnabled: Bool = true

  public var hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .light
  public var hapticIntensity: CGFloat = 1.0

  /// The highest possible value for the stepper.
  ///  The default value for this property is 1
  public var maximumValue: Double = 100

  /// The lowest possible value for the stepper.
  ///  The default value for this property is 0
  public var minimumValue: Double = 1

  /// The step or increment/decrement value for the stepper.
  ///  The default value for this property is 0.1
  public var stepValue: Double = 1

  /**
   The numeric value of the stepper.

   When the value changes, the stepper sends the UIControlEventValueChanged flag to its target (see addTarget:action:forControlEvents:).

   The default value for this property is 0.
   */
  public var value: Double = 0 {
    didSet {
      countLabel.text = String(format: "%.\(decimalPlaces)f", value)

      if value != oldValue {
        sendActions(for: .valueChanged)
      }
    }
  }

  /// The number of decimal places that is displayed in the label for the value.
  ///  To display integers, set this property to zero
  ///  The default value for this property is 1
  public var decimalPlaces: Int = 0 {
    didSet {
      countLabel.text = String(format: "%.\(decimalPlaces)f", value)
    }
  }

  // MARK: - Border

  /// The width of the border for the stepper
  ///  The default value for this property is 1
  public var borderWidth: CGFloat = 1 {
    didSet {
      layer.borderWidth = borderWidth
    }
  }

  /// The color of the border for the stepper
  ///  The default value for this property is `secondaryLabel`
  @IBInspectable public var borderColor: UIColor = .option {
    didSet {
      layer.borderColor = borderColor.cgColor
    }
  }

  // MARK: - Label

  /// The Text for the countLabel
  ///  This is a get-only property & it is optional
  public var countLabelText: String? {
    countLabel.text
  }

  /// The color of the label in the center of the stepper
  ///  The default value for this property is `label`
  @IBInspectable public var labelColor: UIColor = .dark {
    didSet {
      countLabel.textColor = labelColor
    }
  }

  /// The font of the label in the center of the stepper
  ///  The default value for this property is `systemFont(ofSize: 25, weight: .semibold)`
  @IBInspectable public var labelFont = UIFont.systemFont(ofSize: 16, weight: .regular) {
    didSet {
      countLabel.font = labelFont
    }
  }

  /// The color of the plus and minus buttons in the stepper
  ///  The default value for this property is `secondaryLabel`
  public var buttonColor = UIColor.blueGray {
    didSet {
      minusButton.tintColor = buttonColor
      plusButton.tintColor = buttonColor
    }
  }

  /// The weight of the plus and minus buttons in the stepper
  ///  The default value for this property is `bold`
  @IBInspectable public var buttonWeight: UIImage.SymbolWeight = .bold {
    didSet {
      let config = UIImage.SymbolConfiguration(weight: buttonWeight)
      let minusSymbol = UIImage(
        systemName: "minus",
        withConfiguration: config)
      let plusSymbol = UIImage(
        systemName: "plus",
        withConfiguration: config)
      minusButton.setImage(
        minusSymbol,
        for: .normal)
      plusButton.setImage(
        plusSymbol,
        for: .normal)
    }
  }
  /// The padding of the plus and minus buttons in the stepper
  /// The default value for this property is 10
  public var buttonPadding: CGFloat = 10 {
    didSet {
      if
        let plusButtonPadding = plusButtonPadding,
        let minusButtonPadding = minusButtonPadding
      {
        plusButtonPadding.constant = -buttonPadding
        minusButtonPadding.constant = buttonPadding
      }
    }
  }

  /// The width & height of the plus & minus buttons
  /// The default value for this property is 30
  public var buttonSize: CGFloat = 30 {
    didSet {
      plusButton.frame = CGRect(
        x: 0,
        y: 0,
        width: buttonSize,
        height: buttonSize)
      minusButton.frame = CGRect(
        x: 0,
        y: 0,
        width: buttonSize,
        height: buttonSize)

      plusButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
      plusButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
      minusButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
      minusButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
    }
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = frame.height / 2
  }

  // MARK: Private

  private var stepperView = UIView()

  private lazy var countLabel: UILabel = {
    let cLabel = UILabel(frame: bounds)
    cLabel.translatesAutoresizingMaskIntoConstraints = false
    cLabel.font = labelFont
    cLabel.textColor = labelColor
    cLabel.textAlignment = .center
    return cLabel
  }()

  private var plusButtonPadding: NSLayoutConstraint?
  private var minusButtonPadding: NSLayoutConstraint?

  private lazy var plusButton: UIButton = {
    let pBtn = UIButton(frame: CGRect(
      x: 0,
      y: 0,
      width: buttonSize,
      height: buttonSize))
    pBtn.translatesAutoresizingMaskIntoConstraints = false
    pBtn.tintColor = buttonColor
    pBtn.setTitle("", for: .normal)
    pBtn.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
    let config = UIImage.SymbolConfiguration(weight: buttonWeight)
    let plusSymbol = UIImage(
      systemName: "plus",
      withConfiguration: config)
    pBtn.setImage(
      plusSymbol,
      for: .normal)
    pBtn.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
    pBtn.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
    return pBtn
  }()

  private lazy var minusButton: UIButton = {
    let mBtn = UIButton(frame: CGRect(
      x: 0,
      y: 0,
      width: buttonSize,
      height: buttonSize))
    mBtn.translatesAutoresizingMaskIntoConstraints = false
    mBtn.tintColor = buttonColor
    mBtn.setTitle("", for: .normal)
    mBtn.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
    let config = UIImage.SymbolConfiguration(weight: buttonWeight)
    let plusSymbol = UIImage(
      systemName: "minus",
      withConfiguration: config)
    mBtn.setImage(
      plusSymbol,
      for: .normal)
    mBtn.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
    mBtn.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
    return mBtn
  }()

  private func hapticsHandler() {
    if isHapticsEnabled {
      UIImpactFeedbackGenerator(style: hapticStyle)
        .impactOccurred(intensity: hapticIntensity)
    }
  }

  // MARK: - Actions

  /// This is the action for the plus button
  /// The value is incremented if it is less than the maximumValue property
  /// - Parameter sender: Plus UIButton
  @objc
  private func plusTapped(_ sender: UIButton) {
    if value + stepValue > maximumValue { return }
    value += stepValue
    hapticsHandler()
  }

  /// This is the action for the minus button
  /// The value is decremented if it is greater than the minimumValue property
  /// - Parameter sender: Minus UIButton
  @objc
  private func minusTapped(_ sender: UIButton) {
    if value - stepValue < minimumValue { return }
    value -= stepValue
    hapticsHandler()
  }

  // MARK: - Setup

  private func setup() {
    stepperView.backgroundColor = .clear
    stepperView.addSubview(plusButton)
    stepperView.addSubview(minusButton)
    stepperView.addSubview(countLabel)
    addSubview(stepperView)
    stepperView.translatesAutoresizingMaskIntoConstraints = false
    stepperView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    stepperView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    stepperView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    stepperView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    countLabel.centerXAnchor.constraint(equalTo: stepperView.centerXAnchor).isActive = true
    countLabel.centerYAnchor.constraint(equalTo: stepperView.centerYAnchor).isActive = true

    plusButton.removeConstraints(plusButton.constraints)
    minusButton.removeConstraints(minusButton.constraints)

    plusButtonPadding = plusButton.trailingAnchor.constraint(equalTo: stepperView.trailingAnchor, constant: -buttonPadding)
    minusButtonPadding = minusButton.leadingAnchor.constraint(equalTo: stepperView.leadingAnchor, constant: buttonPadding)
    plusButton.centerYAnchor.constraint(equalTo: stepperView.centerYAnchor).isActive = true
    minusButton.centerYAnchor.constraint(equalTo: stepperView.centerYAnchor).isActive = true

    plusButtonPadding?.isActive = true
    minusButtonPadding?.isActive = true
  }
}
