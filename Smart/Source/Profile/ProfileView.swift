//
//  ProfileView.swift
//  StartUp
//
//  Created by Aleksei Smirnov on 09.04.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, content: {
                NameLine()
                    .padding(.top, 10)
                PhoneLine()
                    .padding(.top, 10)
                MenuLine(menuItem: .subscription)
                    .padding(.top, 20)
                MenuLine(menuItem: .restorePurchases)
                    .padding(.top, 20)
//                MenuLine(menuItem: .addresses)
//                    .padding(.top, 30)
//                MenuLine(menuItem: .orders)
//                    .padding(.top, 20)
                MenuLine(menuItem: .info)
                    .padding(.top, 20)
                Spacer()
            })
        }
        .background(Color(.mainBackground))
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
