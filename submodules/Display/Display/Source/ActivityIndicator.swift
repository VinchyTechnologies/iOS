//
//  ActivityIndicator.swift
//  Display
//
//  Created by Aleksei Smirnov on 27.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

//import Darwin
import UIKit

public final class ActivityIndicatorView: UIView {

    private static let animationTiming: TimeInterval = 0.25
    private static let rotateAnimationKey = "vinchy_spinnerRotate_animation"

    /**
    Свойство отвечает за старт и остановку анимации

    - `true` запускает анимацию
    - `false` останавливает анимацию
    */
    public var isAnimating = false {
        didSet {
            if isAnimating { startSpinnerAnimation() } else { stopSpinnerAnimation() }
        }
    }

    var color: UIColor? = .accent {
        didSet {
            spinnerImageView?.tintColor = color
        }
    }

    /// Функция, которая будет выполнена после запуска анимации
    var indicatorShow: (() -> Void)?

    /// Функция, которая будет выполнена после остановки анимации
    var indicatorHide: (() -> Void)?

    var spinnerImageView: UIImageView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        spinnerImageView = prepareImageView()
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

    // MARK: - Объявление типов

    private enum Axis: String {

        case vertical = "V"
        case horizontal = "H"

    }



    // MARK: - Публичные функции

    func fillView(
        _ viewToFill: UIView? = nil,
        padding: CGFloat,
        priority: UILayoutPriority = UILayoutPriority.required) {
        let edgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)

        fillView(viewToFill, insets: edgeInsets)
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

    func makeCenter(_ toView: UIView? = nil, constant: CGFloat = 0.0) {
        makeCenterX(toView, constant: constant)
        makeCenterY(toView, constant: constant)
    }

    func makeCenterX(_ toView: UIView? = nil, constant: CGFloat = 0.0) {
        makeEqual(toView ?? superview, attribute: .centerX, constant: constant)
    }

    func makeCenterY(_ toView: UIView? = nil, constant: CGFloat = 0.0) {
        makeEqual(toView ?? superview, attribute: .centerY, constant: constant)
    }

    @discardableResult
    func makeLeadingTo(_ toView: UIView? = nil,
                       relatedBy: NSLayoutConstraint.Relation = .equal,
                       constant: CGFloat = 0.0,
                       priority: UILayoutPriority = UILayoutPriority.required) -> NSLayoutConstraint {
        return make(
            toView ?? superview,
            attribute: .leading,
            relatedBy: relatedBy,
            constant: constant,
            priority: priority)
    }

    @discardableResult
    func makeTrailingTo(_ toView: UIView? = nil,
                        relatedBy: NSLayoutConstraint.Relation = .equal,
                        constant: CGFloat = 0.0,
                        priority: UILayoutPriority = UILayoutPriority.required) -> NSLayoutConstraint {
        return make(toView ?? superview,
                    attribute: .trailing,
                    relatedBy: relatedBy,
                    constant: constant,
                    priority: priority)
    }

    @discardableResult
    func makeTopTo(_ toView: UIView? = nil,
                   relatedBy: NSLayoutConstraint.Relation = .equal,
                   constant: CGFloat = 0.0,
                   priority: UILayoutPriority = UILayoutPriority.required) -> NSLayoutConstraint {
        return make(toView ?? superview,
                    attribute: .top,
                    relatedBy: relatedBy,
                    constant: constant,
                    priority: priority)
    }

    @discardableResult
    func makeBottomTo(_ toView: UIView? = nil,
                      relatedBy: NSLayoutConstraint.Relation = .equal,
                      constant: CGFloat = 0.0,
                      priority: UILayoutPriority = UILayoutPriority.required) -> NSLayoutConstraint {
        return make(toView ?? superview,
                    attribute: .bottom,
                    relatedBy: relatedBy,
                    constant: constant,
                    priority: priority)
    }

    @discardableResult
    func makeHeight(
        _ toView: UIView? = nil,
        relatedBy: NSLayoutConstraint.Relation = .equal,
        constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return make(toView,
                    attribute: .height,
                    toAttribute: toView == .none ? .notAnAttribute : .height,
                    relatedBy: relatedBy,
                    constant: constant)
    }

    func makeWidth(
        _ toView: UIView? = nil,
        relatedBy: NSLayoutConstraint.Relation = .equal,
        constant: CGFloat = 0.0) {
        make(toView,
             attribute: .width,
             toAttribute: toView == .none ? .notAnAttribute : .width,
             relatedBy: relatedBy,
             constant: constant)
    }

    func makeEqual(
        _ toView: UIView? = nil,
        attribute: NSLayoutConstraint.Attribute,
        toAttribute: NSLayoutConstraint.Attribute? = nil,
        constant: CGFloat = 0.0) {
        let toAttribute = toAttribute ?? attribute

        make(toView ?? superview,
             attribute: attribute,
             toAttribute: toAttribute,
             relatedBy: .equal,
             constant: constant)
    }

    func makeGreaterThanOrEqual(
        _ toView: UIView? = nil,
        attribute: NSLayoutConstraint.Attribute,
        toAttribute: NSLayoutConstraint.Attribute? = nil,
        constant: CGFloat = 0.0) {
        let toAttribute = toAttribute ?? attribute

        make(toView ?? superview,
             attribute: attribute,
             toAttribute: toAttribute,
             relatedBy: .greaterThanOrEqual,
             constant: constant)
    }


    func makeLessThanOrEqual(
        _ toView: UIView? = nil,
        attribute: NSLayoutConstraint.Attribute,
        toAttribute: NSLayoutConstraint.Attribute? = nil,
        constant: CGFloat = 0.0) {
        let toAttribute = toAttribute ?? attribute

        make(toView ?? superview,
             attribute: attribute,
             toAttribute: toAttribute,
             relatedBy: .lessThanOrEqual,
             constant: constant)
    }



    // MARK: - Приватные функции

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

    @discardableResult
    private func make(
        _ toView: UIView? = nil,
        attribute: NSLayoutConstraint.Attribute,
        toAttribute: NSLayoutConstraint.Attribute? = nil,
        relatedBy: NSLayoutConstraint.Relation,
        constant: CGFloat = 0.0,
        priority: UILayoutPriority = UILayoutPriority.required) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false

        let toAttribute = toAttribute ?? attribute

        let ownerView = toView ?? self

        let constraint = NSLayoutConstraint(
            item: self,
            attribute: attribute,
            relatedBy: relatedBy,
            toItem: toView,
            attribute: toAttribute,
            multiplier: 1.0,
            constant: constant)

        constraint.priority = priority

        ownerView.addConstraint(constraint)

        return constraint
    }
}
