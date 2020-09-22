//
//  SceneDelegate.swift
//  Smart
//
//  Created by Aleksei Smirnov on 03.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Core

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScence = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScence)
        window?.windowScene = windowScence
        window?.backgroundColor = .mainBackground
//        UserDefaultsConfig.isAdult = false
//        UserDefaultsConfig.isAgreedToTermsAndConditions = false

        if !(UserDefaultsConfig.isAdult && UserDefaultsConfig.isAgreedToTermsAndConditions) {
            let confirmToStartViewController = ConfirmToStartViewController()
            confirmToStartViewController.delegate = self
            window?.rootViewController = confirmToStartViewController
        } else {
            window?.rootViewController = TabBarController()
        }

        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate: ConfirmToStartViewControllerDelegate {
    func didConfirmAgeAndAgreement() {
        UIApplication.shared.asKeyWindow?.setRootViewController(TabBarController(), options: .init(direction: .toBottom, style: .easeInOut))
    }
}


public extension UIWindow {

    /// Transition Options
    struct TransitionOptions {

        /// Curve of animation
        ///
        /// - linear: linear
        /// - easeIn: ease in
        /// - easeOut: ease out
        /// - easeInOut: ease in - ease out
        public enum Curve {
            case linear
            case easeIn
            case easeOut
            case easeInOut

            /// Return the media timing function associated with curve
            internal var function: CAMediaTimingFunction {
                let key: String!
                switch self {
                case .linear:        key = CAMediaTimingFunctionName.linear.rawValue
                case .easeIn:        key = CAMediaTimingFunctionName.easeIn.rawValue
                case .easeOut:        key = CAMediaTimingFunctionName.easeOut.rawValue
                case .easeInOut:    key = CAMediaTimingFunctionName.easeInEaseOut.rawValue
                }
                return CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: key))
            }
        }

        /// Direction of the animation
        ///
        /// - fade: fade to new controller
        /// - toTop: slide from bottom to top
        /// - toBottom: slide from top to bottom
        /// - toLeft: pop to left
        /// - toRight: push to right
        public enum Direction {
            case fade
            case toTop
            case toBottom
            case toLeft
            case toRight

            /// Return the associated transition
            ///
            /// - Returns: transition
            internal func transition() -> CATransition {
                let transition = CATransition()
                transition.type = CATransitionType.push
                switch self {
                case .fade:
                    transition.type = CATransitionType.fade
                    transition.subtype = nil
                case .toLeft:
                    transition.subtype = CATransitionSubtype.fromLeft
                case .toRight:
                    transition.subtype = CATransitionSubtype.fromRight
                case .toTop:
                    transition.subtype = CATransitionSubtype.fromTop
                case .toBottom:
                    transition.subtype = CATransitionSubtype.fromBottom
                }
                return transition
            }
        }

        /// Background of the transition
        ///
        /// - solidColor: solid color
        /// - customView: custom view
        public enum Background {
            case solidColor(_: UIColor)
            case customView(_: UIView)
        }

        /// Duration of the animation (default is 0.60s)
        public var duration: TimeInterval = 0.6

        /// Direction of the transition (default is `toRight`)
        public var direction: TransitionOptions.Direction = .toRight

        /// Style of the transition (default is `linear`)
        public var style: TransitionOptions.Curve = .linear

        /// Background of the transition (default is `nil`)
        public var background: TransitionOptions.Background? = .solidColor(.mainBackground)

        /// Initialize a new options object with given direction and curve
        ///
        /// - Parameters:
        ///   - direction: direction
        ///   - style: style
        public init(direction: TransitionOptions.Direction = .toRight, style: TransitionOptions.Curve = .linear) {
            self.direction = direction
            self.style = style
        }

        public init() { }

        /// Return the animation to perform for given options object
        internal var animation: CATransition {
            let transition = self.direction.transition()
            transition.duration = self.duration
            transition.timingFunction = self.style.function
            return transition
        }
    }


    /// Change the root view controller of the window
    ///
    /// - Parameters:
    ///   - controller: controller to set
    ///   - options: options of the transition
    func setRootViewController(_ controller: UIViewController, options: TransitionOptions = TransitionOptions()) {

        var transitionWnd: UIWindow? = nil
        if let background = options.background {
            transitionWnd = UIWindow(frame: UIScreen.main.bounds)
            switch background {
            case .customView(let view):
                transitionWnd?.rootViewController = UIViewController.newController(withView: view, frame: transitionWnd!.bounds)
            case .solidColor(let color):
                transitionWnd?.backgroundColor = color
            }
            transitionWnd?.makeKeyAndVisible()
        }


        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .push
        transition.subtype = .fromBottom
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        layer.add(transition, forKey: kCATransition)

        // Make animation
//        self.layer.add(options.animation, forKey: kCATransition)
        self.rootViewController = controller
        self.makeKeyAndVisible()

        if let wnd = transitionWnd {
            DispatchQueue.main.asyncAfter(deadline: (.now() + 1 + options.duration), execute: {
                wnd.removeFromSuperview()
            })
        }
    }
}

internal extension UIViewController {

    /// Create a new empty controller instance with given view
    ///
    /// - Parameters:
    ///   - view: view
    ///   - frame: frame
    /// - Returns: instance
    static func newController(withView view: UIView, frame: CGRect) -> UIViewController {
        view.frame = frame
        let controller = UIViewController()
        controller.view = view
        return controller
    }

}
