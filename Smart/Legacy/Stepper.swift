//
//  Stepper.swift
//  Smart
//
//  Created by Aleksei Smirnov on 23.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

protocol StepperDelegate: AnyObject {
    func plus()
    func minus()
}

public class Stepper: UIView {

    private var forwardButton: UIButton?
    private var backwardButton: UIButton?
    private var counterLabel: UILabel?

    weak var delegate: StepperDelegate?

    public var borderWidth: CGFloat = 1

    public  var font: UIFont = UIFont.systemFont(ofSize: 24) {
        didSet {
            counterLabel?.font = font
            forwardButton?.setAttributedTitle(NSAttributedString(string: forwardTitle, attributes: [NSAttributedString.Key.font:font]), for: .normal)
            backwardButton?.setAttributedTitle(NSAttributedString(string: backwardTitle, attributes: [NSAttributedString.Key.font:font]), for: .normal)
        }
    }

    public var buttonBackgroundColor: UIColor? = .mainBackground {
        didSet {
            forwardButton?.backgroundColor = buttonBackgroundColor
            backwardButton?.backgroundColor = buttonBackgroundColor
        }
    }

    public var counterBackgroundColor: UIColor? = .mainBackground {
        didSet {
            counterLabel?.backgroundColor = counterBackgroundColor
        }
    }

    public var counterTitleColor: UIColor? = .dark {
        didSet {
            counterLabel?.textColor = counterTitleColor
        }
    }

    public var forwardTitle: String = "+"
    public var backwardTitle: String = "-"
    public var maxValue: Int = 100
    public var minValue: Int = 0
    public var current: Int = 0
    public var step: Int = 1

    public override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 12
        clipsToBounds = true

        let widthOfComponent  = bounds.width / 3
        let heightOfComponent = bounds.height
        let maxFontSize       = min(widthOfComponent, heightOfComponent)

        let counterLabel = UILabel(frame: CGRect(x: widthOfComponent, y: 0, width: bounds.width - (widthOfComponent*2), height: heightOfComponent))
        counterLabel.adjustsFontSizeToFitWidth = true
        counterLabel.textAlignment = .center
        counterLabel.font  = font.withSize(maxFontSize)
        addSubview(counterLabel)
        self.counterLabel  = counterLabel

        let forwardButton = UIButton(frame: CGRect(x: bounds.width - widthOfComponent, y: 0, width: widthOfComponent, height: heightOfComponent))
        forwardButton.addTarget(self, action: #selector(forward), for: .touchUpInside)
        addSubview(forwardButton)
        self.forwardButton = forwardButton

        let backwardButton = UIButton(frame: CGRect(x: 0, y: 0, width: widthOfComponent, height: heightOfComponent))
        backwardButton.addTarget(self, action: #selector(backward), for: .touchUpInside)

        backwardButton.setTitle(backwardTitle, for: .normal)
        addSubview(backwardButton)
        self.backwardButton = backwardButton

        configApperance()
    }

    required public init?(coder aDecoder: NSCoder) { fatalError() }

    public override func layoutSubviews() {
        super.layoutSubviews()
        configApperance()
    }

    private func configApperance() {

        let widthOfComponent  = bounds.width / 3
        let heightOfComponent = bounds.height
        let maxFontSize       = min(widthOfComponent, heightOfComponent)
        font = UIFont.systemFont(ofSize: maxFontSize/2)
        counterLabel?.frame   = CGRect(x: widthOfComponent, y: 0, width: bounds.width - (widthOfComponent*2), height: heightOfComponent)
        forwardButton?.frame  = CGRect(x: bounds.width - widthOfComponent, y: 0, width: widthOfComponent, height: heightOfComponent)
        backwardButton?.frame = CGRect(x: 0, y: 0, width: widthOfComponent, height: heightOfComponent)

        forwardButton?.backgroundColor = buttonBackgroundColor
        backwardButton?.backgroundColor = buttonBackgroundColor
        counterLabel?.backgroundColor = counterBackgroundColor

        forwardButton?.setAttributedTitle(NSAttributedString(string: forwardTitle, attributes: [NSAttributedString.Key.font:font]), for: .normal)
        backwardButton?.setAttributedTitle(NSAttributedString(string: backwardTitle, attributes: [NSAttributedString.Key.font:font]), for: .normal)

        if let titleColor = counterTitleColor {
            counterLabel?.textColor = titleColor
        } else {
            counterLabel?.textColor = tintColor
        }

        counterLabel?.font = Font.regular(14)


        layer.borderWidth = borderWidth
        configCounter()

    }

    @objc private func forward() {
        if current + step > maxValue {
            return
        }
        current += step
        configCounter()
        delegate?.plus()
    }

    @objc private func backward() {
        if current - step < minValue { return }
        current -= step
        configCounter()
        delegate?.minus()
    }

    private func configCounter() {
        counterLabel?.text = String(current)
        counterLabel?.baselineAdjustment = .alignCenters
//        delegate?.valueChanged(value: current)
    }
}
