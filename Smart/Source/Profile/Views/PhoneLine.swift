//
//  PhoneLine.swift
//  StartUp
//
//  Created by Aleksei Smirnov on 09.04.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import SwiftUI

struct PhoneLine: View {
    var body: some View {
        HStack {
            Text("email@gmail.com")
                .font(.system(.callout, design: .default))
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct PhoneLine_Previews: PreviewProvider {
    static var previews: some View {
        PhoneLine()
    }
}
