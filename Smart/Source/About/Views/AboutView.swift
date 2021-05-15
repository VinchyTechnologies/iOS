//
//  AboutView.swift
//  Smart
//
//  Created by Алексей Смирнов on 31.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import SwiftUI
import StringFormatting
import Display

struct AboutViewModel: ViewModelProtocol {
  
  fileprivate let logoText: String?
  fileprivate let versionText: String?
  
  public init(logoText: String?, versionText: String?) {
    self.logoText = logoText
    self.versionText = versionText
  }
}

struct AboutView: View {
  
  private let viewModel: AboutViewModel
  
  init(viewModel: AboutViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    VStack(spacing: 10) {
      
      if let logoText = viewModel.logoText {
        Text(logoText)
          .font(.largeTitle)
          .bold()
          .foregroundColor(Color(.accent))
      }
      
      if let versionText = viewModel.versionText {
        Text(versionText)
          .font(.body)
          .foregroundColor(Color(.dark))
      }
    }
  }
}

struct AboutView_Previews: PreviewProvider {
  static var previews: some View {
    AboutView(viewModel: AboutViewModel(logoText: "Vinchy", versionText: "1.5"))
  }
}
