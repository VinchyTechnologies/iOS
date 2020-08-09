//
//  TabBarController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 16.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display
import StringFormatting

final class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self

        tabBar.isTranslucent = false
        UITabBar.appearance().tintColor = .dark
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .blueGray

        let imageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .default)

        let main = Assembly.buildMainModule()
        main.tabBarItem = UITabBarItem(title: localized("explore").firstLetterUppercased(), image: UIImage(systemName: "square.grid.2x2", withConfiguration: imageConfig), selectedImage: nil)

        let love = Assembly.buildLoveModule()
        love.tabBarItem = UITabBarItem(title: localized("favourites").firstLetterUppercased(), image: UIImage(systemName: "heart", withConfiguration: imageConfig), selectedImage: nil)

        let notes = NavigationController(rootViewController: NotesViewController())
        notes.tabBarItem = UITabBarItem(title: localized("notes").firstLetterUppercased(), image: UIImage(systemName: "square.and.pencil", withConfiguration: imageConfig), selectedImage: nil)

        let chat = NavigationController(rootViewController: BasicExampleViewController()) 
        chat.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bubble.left"), selectedImage: nil)

//        let cart = NavigationController(rootViewController: CartViewController())
//        cart.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "cart"), selectedImage: nil)

        let profile = Assembly.buildProfileModule()
        profile.tabBarItem = UITabBarItem(title: localized("info"), image: /*UIImage(systemName: "person")*/ UIImage(systemName: "circle.grid.3x3", withConfiguration: imageConfig), selectedImage: nil)

        let somelier = Assembly.buildSomelierModule()
        somelier.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "rectangle.stack"), selectedImage: nil)

        [main, love, notes, profile].forEach { (controller) in
            controller.tabBarItem.titlePositionAdjustment = .init(horizontal: 0, vertical: -3)
            controller.tabBarItem.imageInsets = .init(top: 10, left: 0, bottom: 0, right: 0)
        }

        viewControllers = [main, love, /*somelier,*/ notes, /*chat, cart,*/ profile]

    }

}
