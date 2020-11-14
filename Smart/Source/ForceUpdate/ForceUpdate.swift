//
//  ForceUpdate.swift
//  Smart
//
//  Created by Aleksei Smirnov on 21.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import SwiftUI
import Core
import StringFormatting

struct ForceUpdateView: View, OpenURLProtocol {
  var body: some View {
    VStack {
      Spacer()
      Text(localized("unavailable_version"))
        .bold()
      Spacer()
      Button(action: {
        openAppStore()
      }, label: {
        Text(localized("open_appstore"))
          .foregroundColor(Color(.mainBackground))
          .bold()
      })
      .frame(width: UIScreen.main.bounds.width - 40, height: 48, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
      .background(Color(.accent))
      .cornerRadius(24)
      .padding()
    }
  }

  private func openAppStore() {
    open(urlString: localized("appstore_link")) {
    }
  }
}

struct ForceUpdateView_Previews: PreviewProvider {
  static var previews: some View {
    ForceUpdateView()
  }
}
