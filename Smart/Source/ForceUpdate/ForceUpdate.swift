//
//  ForceUpdate.swift
//  Smart
//
//  Created by Aleksei Smirnov on 21.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import SwiftUI

struct ForceUpdateView: View {
  var body: some View {
    VStack {
      Spacer()
      Text("Sorry, this version doesn't support anymore. Please, update the app") // TODO: - localizze
        .bold()
      Spacer()
      Button(action: {
        openAppStore()
      }, label: {
        Text("Go to Appstore") // TODO: - localizze
          .foregroundColor(Color(.mainBackground))
          .bold()
      })
      .frame(width: UIScreen.main.bounds.width - 40, height: 48, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
      .background(Color(.accent))
      .cornerRadius(24)
    }
  }

  private func openAppStore() {
    UIApplication.shared.open(URL(string: openAppStoreURL)!, options: [:])
  }
}

struct ForceUpdateView_Previews: PreviewProvider {
  static var previews: some View {
    ForceUpdateView()
  }
}
