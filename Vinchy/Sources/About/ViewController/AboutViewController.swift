//
//  AboutViewController.swift
//  Coffee
//
//  Created by Алексей Смирнов on 12/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//
// swiftlint:disable all

import Core
import Display
import StringFormatting
import SwiftUI

final class AboutViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .mainBackground
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.title = localized("about_the_app").firstLetterUppercased()

    let versionText = localized("version") + " " + String(describing: Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)
    let logoText = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String
    let childView = UIHostingController(rootView: AboutView(viewModel: AboutViewModel(logoText: logoText, versionText: versionText)))
    addChild(childView)
    childView.view.backgroundColor = .mainBackground
    view.addSubview(childView.view)
    childView.view.fill()
    childView.didMove(toParent: self)
  }
}
