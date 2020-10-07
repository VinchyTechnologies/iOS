//
//  ASPageControl.swift
//  Display
//
//  Created by Aleksei Smirnov on 18.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//
// swiftlint:disable all

import UIKit

public final class ASPageControl: UIControl {

    /// The number of page indicators of the page control. Default is 0.
    public var numberOfPages: Int = 0 {
        didSet {
            self.setNeedsCreateIndicators()
        }
    }

    /// The current page, highlighted by the page control. Default is 0.
    public var currentPage: Int = 0 {
        didSet {
            self.setNeedsUpdateIndicators()
        }
    }

    /// The spacing to use of page indicators in the page control.
    public var itemSpacing: CGFloat = 6 {
        didSet {
            self.setNeedsUpdateIndicators()
        }
    }

    /// The spacing to use between page indicators in the page control.
    public var interitemSpacing: CGFloat = 6 {
        didSet {
            self.setNeedsLayout()
        }
    }

    /// The distance that the page indicators is inset from the enclosing page control.
    public var contentInsets: UIEdgeInsets = .zero {
        didSet {
            self.setNeedsLayout()
        }
    }

    /// The horizontal alignment of content within the control’s bounds. Default is center.
    public override var contentHorizontalAlignment: UIControl.ContentHorizontalAlignment {
        didSet {
            self.setNeedsLayout()
        }
    }

    /// Hide the indicator if there is only one page. default is NO
    public var hidesForSinglePage: Bool = false {
        didSet {
            self.setNeedsUpdateIndicators()
        }
    }

    internal var strokeColors: [UIControl.State: UIColor] = [:]
    internal var fillColors: [UIControl.State: UIColor] = [:]
    internal var paths: [UIControl.State: UIBezierPath] = [:]
    internal var images: [UIControl.State: UIImage] = [:]
    internal var alphas: [UIControl.State: CGFloat] = [:]
    internal var transforms: [UIControl.State: CGAffineTransform] = [:]

    private weak var contentView: UIView!

    private var needsUpdateIndicators = false
    private var needsCreateIndicators = false
    private var indicatorLayers = [CAShapeLayer]()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = {
            let x = self.contentInsets.left
            let y = self.contentInsets.top
            let width = self.frame.width - self.contentInsets.left - self.contentInsets.right
            let height = self.frame.height - self.contentInsets.top - self.contentInsets.bottom
            let frame = CGRect(x: x, y: y, width: width, height: height)
            return frame
        }()
    }

    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        let diameter = self.itemSpacing
        let spacing = self.interitemSpacing
        var x: CGFloat = {
            switch self.contentHorizontalAlignment {
            case .left, .leading:
                return 0
            case .center, .fill:
                let midX = self.contentView.bounds.midX
                let amplitude = CGFloat(self.numberOfPages/2) * diameter + spacing*CGFloat((self.numberOfPages-1)/2)
                return midX - amplitude
            case .right, .trailing:
                let contentWidth = diameter * CGFloat(self.numberOfPages) + CGFloat(self.numberOfPages-1)*spacing
                return contentView.frame.width - contentWidth
            default:
                return 0
            }
        }()

        for (index,value) in self.indicatorLayers.enumerated() {
            let state: UIControl.State = (index == self.currentPage) ? .selected : .normal
            let image = self.images[state]
            let size = image?.size ?? CGSize(width: diameter, height: diameter)
            let origin = CGPoint(x: x - (size.width - diameter) * 0.5,
                                 y: self.contentView.bounds.midY-size.height*0.5)
            value.frame = CGRect(origin: origin, size: size)
            x = x + spacing + diameter
        }

    }

    /// Sets the stroke color for page indicators to use for the specified state. (selected/normal).
    ///
    /// - Parameters:
    ///   - strokeColor: The stroke color to use for the specified state.
    ///   - state: The state that uses the specified stroke color.
    @objc(setStrokeColor:forState:)
    public func setStrokeColor(_ strokeColor: UIColor?, for state: UIControl.State) {
        guard self.strokeColors[state] != strokeColor else {
            return
        }
        self.strokeColors[state] = strokeColor
        self.setNeedsUpdateIndicators()
    }

    /// Sets the fill color for page indicators to use for the specified state. (selected/normal).
    ///
    /// - Parameters:
    ///   - fillColor: The fill color to use for the specified state.
    ///   - state: The state that uses the specified fill color.
    @objc(setFillColor:forState:)
    public func setFillColor(_ fillColor: UIColor?, for state: UIControl.State) {
        guard self.fillColors[state] != fillColor else {
            return
        }
        self.fillColors[state] = fillColor
        self.setNeedsUpdateIndicators()
    }

    /// Sets the image for page indicators to use for the specified state. (selected/normal).
    ///
    /// - Parameters:
    ///   - image: The image to use for the specified state.
    ///   - state: The state that uses the specified image.
    @objc(setImage:forState:)
    public func setImage(_ image: UIImage?, for state: UIControl.State) {
        guard self.images[state] != image else {
            return
        }
        self.images[state] = image
        self.setNeedsUpdateIndicators()
    }

    @objc(setAlpha:forState:)

    /// Sets the alpha value for page indicators to use for the specified state. (selected/normal).
    ///
    /// - Parameters:
    ///   - alpha: The alpha value to use for the specified state.
    ///   - state: The state that uses the specified alpha.
    public func setAlpha(_ alpha: CGFloat, for state: UIControl.State) {
        guard self.alphas[state] != alpha else {
            return
        }
        self.alphas[state] = alpha
        self.setNeedsUpdateIndicators()
    }

    /// Sets the path for page indicators to use for the specified state. (selected/normal).
    ///
    /// - Parameters:
    ///   - path: The path to use for the specified state.
    ///   - state: The state that uses the specified path.
    @objc(setPath:forState:)
    public func setPath(_ path: UIBezierPath?, for state: UIControl.State) {
        guard self.paths[state] != path else {
            return
        }
        self.paths[state] = path
        self.setNeedsUpdateIndicators()
    }

    // MARK: - Private functions

    private func commonInit() {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.clear
        self.addSubview(view)
        self.contentView = view
        self.isUserInteractionEnabled = false
    }

    private func setNeedsUpdateIndicators() {
        self.needsUpdateIndicators = true
        self.setNeedsLayout()
        DispatchQueue.main.async {
            self.updateIndicatorsIfNecessary()
        }
    }

    private func updateIndicatorsIfNecessary() {
        guard self.needsUpdateIndicators else {
            return
        }
        guard self.indicatorLayers.count > 0 else {
            return
        }
        self.needsUpdateIndicators = false
        self.contentView.isHidden = self.hidesForSinglePage && self.numberOfPages <= 1
        if !self.contentView.isHidden {
            self.indicatorLayers.forEach { (layer) in
                layer.isHidden = false
                self.updateIndicatorAttributes(for: layer)
            }
        }
    }

    private func updateIndicatorAttributes(for layer: CAShapeLayer) {
        let index = self.indicatorLayers.firstIndex(of: layer)
        let state: UIControl.State = index == self.currentPage ? .selected : .normal
        if let image = self.images[state] {
            layer.strokeColor = nil
            layer.fillColor = nil
            layer.path = nil
            layer.contents = image.cgImage
        } else {
            layer.contents = nil
            let strokeColor = self.strokeColors[state]
            let fillColor = self.fillColors[state]
            if strokeColor == nil && fillColor == nil {
                layer.fillColor = (state == .selected ? UIColor.black : UIColor.gray).cgColor
                layer.strokeColor = nil
            } else {
                layer.strokeColor = strokeColor?.cgColor
                layer.fillColor = fillColor?.cgColor
            }
            layer.path = self.paths[state]?.cgPath ?? UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.itemSpacing, height: self.itemSpacing)).cgPath
        }
        if let transform = self.transforms[state] {
            layer.transform = CATransform3DMakeAffineTransform(transform)
        }
        layer.opacity = Float(self.alphas[state] ?? 1.0)
    }

    private func setNeedsCreateIndicators() {
        self.needsCreateIndicators = true
        DispatchQueue.main.async {
            self.createIndicatorsIfNecessary()
        }
    }

    private func createIndicatorsIfNecessary() {
        guard self.needsCreateIndicators else {
            return
        }
        self.needsCreateIndicators = false
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if self.currentPage >= self.numberOfPages {
            self.currentPage = self.numberOfPages - 1
        }
        self.indicatorLayers.forEach { (layer) in
            layer.removeFromSuperlayer()
        }
        self.indicatorLayers.removeAll()
        for _ in 0..<self.numberOfPages {
            let layer = CAShapeLayer()
            layer.actions = ["bounds": NSNull()]
            self.contentView.layer.addSublayer(layer)
            self.indicatorLayers.append(layer)
        }
        self.setNeedsUpdateIndicators()
        self.updateIndicatorsIfNecessary()
        CATransaction.commit()
    }

}

extension UIControl.State: Hashable {
    public var hashValue: Int {
        return Int((6777 * self.rawValue + 3777) % UInt(UInt16.max))
    }
}
