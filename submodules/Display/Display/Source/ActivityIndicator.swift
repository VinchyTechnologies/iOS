//
//  ActivityIndicator.swift
//  Display
//
//  Created by Aleksei Smirnov on 27.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

public final class ActivityIndicatorView: UIView {

    private static let animationTiming: TimeInterval = 0.25
    private static let rotateAnimationKey = "vinchy_spinnerRotate_animation"

    public var isAnimating = false {
        didSet {
            if isAnimating {
                startSpinnerAnimation()
            } else {
                stopSpinnerAnimation()
            }
        }
    }

    var color: UIColor? = .accent {
        didSet {
            spinnerImageView.tintColor = color
        }
    }

    /// Функция, которая будет выполнена после запуска анимации
    var indicatorShow: (() -> Void)?

    /// Функция, которая будет выполнена после остановки анимации
    var indicatorHide: (() -> Void)?

    lazy var spinnerImageView: UIImageView = prepareImageView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    private func startSpinnerAnimation() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = 2.0 * .pi
        rotateAnimation.duration = 0.9
        rotateAnimation.repeatCount = .infinity
        rotateAnimation.isRemovedOnCompletion = false

        spinnerImageView.layer.add(
            rotateAnimation,
            forKey: ActivityIndicatorView.rotateAnimationKey)

        UIView.animate(
            withDuration: ActivityIndicatorView.animationTiming,
            animations: { self.alpha = 1.0 },
            completion: { _ in
                if let indicatorShow = self.indicatorShow {
                    indicatorShow()
                }
            })
    }

    private func stopSpinnerAnimation() {
        UIView.animate(
            withDuration: ActivityIndicatorView.animationTiming,
            animations: { self.alpha = 0.0 },
            completion: { _ in
                self.spinnerImageView.layer.removeAnimation(
                    forKey: ActivityIndicatorView.rotateAnimationKey)

                if let indicatorHide = self.indicatorHide {
                    indicatorHide()
                }
        })
    }

    func prepareImageView() -> UIImageView {
        alpha = 0.0
        let imageView = UIImageView(image: UIImage(named: "zero-modal-spinner"))
        imageView.tintColor = color
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        imageView.fillView()

        let resistantPriority: UILayoutPriority = UILayoutPriority(rawValue: 990)

        imageView.setContentCompressionResistancePriority(resistantPriority, for: .horizontal)
        imageView.setContentCompressionResistancePriority(resistantPriority, for: .vertical)
        imageView.setContentHuggingPriority(resistantPriority, for: .horizontal)
        imageView.setContentHuggingPriority(resistantPriority, for: .vertical)

        return imageView
    }

}

fileprivate extension UIView {

    private enum Axis: String {
        case vertical = "V"
        case horizontal = "H"
    }

    func fillView(
        _ viewToFill: UIView? = nil,
        insets: UIEdgeInsets = UIEdgeInsets.zero,
        priority: UILayoutPriority = UILayoutPriority.required) {
        guard let viewToFill = viewToFill ?? superview else {
            return
        }

        translatesAutoresizingMaskIntoConstraints = false

        viewToFill.addConstraints(
            constructPaddings(.vertical,
                              values: CGPoint(x: insets.top, y: insets.bottom),
                              priority: priority))

        viewToFill.addConstraints(
            constructPaddings(.horizontal, values:
                CGPoint(x: insets.left, y: insets.right),
                              priority: priority))
    }

    private func constructPaddings(
        _ axis: Axis,
        values: CGPoint,
        priority: UILayoutPriority = UILayoutPriority.required) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(
            withVisualFormat: axis.rawValue + ":|-left@priority-[view]-right@priority-|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: ["left": values.x, "right": values.y, "priority": priority],
            views: ["view": self])
    }
}
