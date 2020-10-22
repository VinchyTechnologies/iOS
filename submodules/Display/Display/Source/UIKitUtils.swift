//
//  UIKitUtils.swift
//  Display
//
//  Created by Aleksei Smirnov on 17.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

extension UIColor {
    public static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
}

public protocol Reusable: AnyObject {
    static var reuseId: String { get }
}

public extension Reusable where Self: UITableViewCell {
    static var reuseId: String {
        return String(describing: self)
    }
}

public extension Reusable where Self: UICollectionViewCell {
    static var reuseId: String {
        return String(describing: self)
    }
}

public extension Reusable where Self: UICollectionReusableView {
    static var reuseId: String {
        return String(describing: self)
    }
}

public extension UICollectionView {

    typealias ReusableCollectionViewCell = Reusable & UICollectionViewCell

    func register(_ array: ReusableCollectionViewCell.Type...) {
        array.forEach { (type) in
            register(type.self, forCellWithReuseIdentifier: type.reuseId)
        }
    }
}

public protocol ViewModelProtocol { }

public protocol Decoratable {

    associatedtype ViewModel: ViewModelProtocol

    func decorate(model: ViewModel)
}

public extension UIApplication {

    var asKeyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .map({ $0 as? UIWindowScene })
            .compactMap({ $0 })
            .first?.windows
            .filter({ $0.isKeyWindow }).first
    }

    static func topViewController(base: UIViewController? = UIApplication.shared.asKeyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }

        return base
    }
}

//public extension UIImage {
//    func imageByMakingWhiteBackgroundTransparent() -> UIImage? {
//        if let rawImageRef = self.cgImage {
//            let colorMasking: [CGFloat] = [250, 255, 250, 255, 250, 255]
//            UIGraphicsBeginImageContext(self.size)
//            if let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking) {
//                UIGraphicsGetCurrentContext()!.translateBy(x: 0.0, y: self.size.height)
//                UIGraphicsGetCurrentContext()!.scaleBy(x: 1.0, y: -1.0)
//                UIGraphicsGetCurrentContext()!.draw(maskedImageRef,
//                                                    in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
//                let result = UIGraphicsGetImageFromCurrentImageContext()
//                UIGraphicsEndImageContext()
//                return result
//            }
//        }
//        return nil
//    }
//}

public extension UIView {
    func fill() {

        guard let superView = superview else {
            return
        }

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.topAnchor),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor),
        ])
    }
}
