//
//  MenuLine.swift
//  StartUp
//
//  Created by Aleksei Smirnov on 09.04.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import SwiftUI
import StringFormatting

enum Menu {

    case addresses, orders, info, subscription, restorePurchases

    var title: String {
        switch self {
        case .addresses:
            return "Адреса"
        case .orders:
            return "Заказы"
        case .info:
            return localized("info").firstLetterUppercased()
        case .subscription:
            return "Подписки"
        case .restorePurchases:
            return "Восстановить покупки"
        }
    }
}

struct MenuLine: View {

    let menuItem: Menu

    var body: some View {
        HStack {
            Text(menuItem.title)
                .bold()
                .font(.system(.title, design: .default))
            Spacer()
        }
        .padding(.horizontal, 20)
        .onTapGesture {
            self.didTapMenuItem()
        }
    }

    private func didTapMenuItem() {
        switch menuItem {
        case .addresses:
            break
//            pushToMapViewController()
        case .orders:
            pushToOrders()
        case .info:
            pushToInfo()
        case .subscription:
            presentSubscriptions()
        case .restorePurchases:
            restorePurchases()
        }
    }

//    private func pushToMapViewController() {
//        if let controller = UIApplication.topViewController() {
//            let backItem = UIBarButtonItem()
//            backItem.title = ""
//            controller.navigationItem.backBarButtonItem = backItem
//            controller.navigationController?.pushViewController(AddressesViewController(), animated: true)
//        }
//    }

    private func restorePurchases() {
        
    }

    private func presentSubscriptions() {
        if let controller = UIApplication.topViewController() {
            let nav = Assembly.buildSubscriptionModule()
            nav.navigationBar.isTranslucent = true
            nav.modalPresentationStyle = .fullScreen
            controller.present(nav, animated: true, completion: nil)
        }
    }

    private func pushToOrders() {
    }

    private func pushToInfo() {
        if let controller = UIApplication.topViewController() {
            let backItem = UIBarButtonItem()
            backItem.title = ""
            controller.navigationItem.backBarButtonItem = backItem

            let moreVC = MoreViewController()
            moreVC.hidesBottomBarWhenPushed = true
            controller.navigationController?.pushViewController(moreVC, animated: true)
        }
    }
}

struct MenuLine_Previews: PreviewProvider {
    static var previews: some View {
        MenuLine(menuItem: .addresses)
    }
}
