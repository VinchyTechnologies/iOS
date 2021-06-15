//
//  AboutView.swift
//  Smart
//
//  Created by Алексей Смирнов on 31.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import StringFormatting
import SwiftUI

// MARK: - AboutViewModel

struct AboutViewModel: ViewModelProtocol {
  fileprivate let logoText: String?
  fileprivate let versionText: String?

  public init(logoText: String?, versionText: String?) {
    self.logoText = logoText
    self.versionText = versionText
  }
}

// MARK: - AboutView

struct AboutView: View {

  // MARK: Lifecycle

  init(viewModel: AboutViewModel) {
    self.viewModel = viewModel
  }

  // MARK: Internal

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

  // MARK: Private

  private let viewModel: AboutViewModel
}

// MARK: - AboutView_Previews

struct AboutView_Previews: PreviewProvider {
  static var previews: some View {
    AboutView(viewModel: AboutViewModel(logoText: "Vinchy", versionText: "1.5"))
  }
}
