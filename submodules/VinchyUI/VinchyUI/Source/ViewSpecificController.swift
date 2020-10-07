//
//  ViewSpecificController.swift
//  VinchyUI
//
//  Created by Aleksei Smirnov on 19.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

//open class ViewSpecificController<V: UIView>: UIViewController {
//
//    public var rootView: V! { return (self.view as! V) }
//
//    override open func loadView() {
//        self.view = V()
//    }
//}

public protocol ViewSpecificController {
    associatedtype RootView: UIView
}

public extension ViewSpecificController where Self: UIViewController {
    func view() -> RootView {
        // swiftlint:disable:next force_cast
        return self.view as! RootView
    }
}
