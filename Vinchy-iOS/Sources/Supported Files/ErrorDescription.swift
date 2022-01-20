//
//  ErrorDescription.swift
//  Smart
//
//  Created by Aleksei Smirnov on 18.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import StringFormatting
import VinchyCore

// MARK: - APIErrorProtocol

protocol APIErrorProtocol {
  var title: String? { get }
  var description: String? { get }
}

// MARK: - APIError + APIErrorProtocol

extension APIError: APIErrorProtocol {
  var title: String? {
    localized("error").firstLetterUppercased()
  }

  var description: String? {
    switch self {
    case .invalidURL, .decodingError, .incorrectStatusCode, .unknown:
      return localized("Error.Unknown")

    case .noInternetConnection:
      return localized("Error.NoInternetConnection")

    case .updateTokensErrorShouldShowAuthScreen:
      return nil
    }
  }
}
