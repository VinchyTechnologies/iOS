//
//  UIKitUtils.swift
//  Display
//
//  Created by Aleksei Smirnov on 17.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - Reusable

public protocol Reusable: AnyObject {
  static var reuseId: String { get }
}

extension Reusable where Self: UITableViewCell {
  public static var reuseId: String {
    String(describing: self)
  }
}

extension Reusable where Self: UICollectionViewCell {
  public static var reuseId: String {
    String(describing: self)
  }
}

extension Reusable where Self: UICollectionReusableView {
  public static var reuseId: String {
    String(describing: self)
  }
}

extension UICollectionView {
  public typealias ReusableCollectionViewCell = Reusable & UICollectionViewCell

  public func register(_ array: ReusableCollectionViewCell.Type...) {
    array.forEach { type in
      register(type.self, forCellWithReuseIdentifier: type.reuseId)
    }
  }
}

// MARK: - ViewModelProtocol

public protocol ViewModelProtocol {}

// MARK: - Decoratable

public protocol Decoratable {
  associatedtype ViewModel: ViewModelProtocol

  func decorate(model: ViewModel)
}

extension UIApplication {
  public var asKeyWindow: UIWindow? {
    UIApplication.shared.connectedScenes
      .filter { $0.activationState == .foregroundActive }
      .map { $0 as? UIWindowScene }
      .compactMap { $0 }
      .first?.windows
      .filter { $0.isKeyWindow }.first
  }

  public static func topViewController(base: UIViewController? = UIApplication.shared.asKeyWindow?.rootViewController) -> UIViewController? {
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

// public extension UIImage {
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
// }

extension UIView {
  public func fill() {
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

extension UIViewController {
  public var isModal: Bool {
    if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
      return false

    } else if presentingViewController != nil {
      return true

    } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
      return true

    } else if tabBarController?.presentingViewController is UITabBarController {
      return true

    } else {
      return false
    }
  }
}
