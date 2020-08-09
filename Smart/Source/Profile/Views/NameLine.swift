//
//  NameLine.swift
//  StartUp
//
//  Created by Aleksei Smirnov on 09.04.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import SwiftUI
import StringFormatting

struct NameLine: View {
    var body: some View {
        HStack {
            Text(localized("what_is_your_name"))
                .bold()
                .font(.system(.title, design: .default))
            Spacer()
        }
        .padding(.horizontal, 20)
        .onTapGesture {
            self.didTapNameLine()
        }
    }

    private func didTapNameLine() {

        if true {
            Assembly.startAuthFlow(completion: nil)
        } else {
            if let controller = UIApplication.topViewController() {
                let backItem = UIBarButtonItem()
                backItem.title = ""
                controller.navigationItem.backBarButtonItem = backItem

                let nameVC = NameViewController()
                nameVC.hidesBottomBarWhenPushed = true
                controller.navigationController?.pushViewController(nameVC, animated: true)
            }
        }
    }
}

struct NameLine_Previews: PreviewProvider {
    static var previews: some View {
        NameLine()
    }
}
