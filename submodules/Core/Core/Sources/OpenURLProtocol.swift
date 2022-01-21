//
//  OpenURLProtocol.swift
//  Core
//
//  Created by Aleksei Smirnov on 18.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - OpenURLProtocol

public protocol OpenURLProtocol {
  func open(urlString: String, errorCompletion: () -> Void)
}

@available(iOSApplicationExtension, unavailable)
extension OpenURLProtocol {
  public func open(urlString: String, errorCompletion: () -> Void) {
    if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
    } else {
      errorCompletion()
    }
  }
}
