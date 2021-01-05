//
//  ImageLoader.swift
//  Display
//
//  Created by Aleksei Smirnov on 05.12.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Nuke

public extension UIImageView {

  func loadBottle(url: URL?) {

    guard let url = url else {
      return
    }
    
    ImageCache.shared.ttl = 30 * 24 * 60 * 60

    var options = ImageLoadingOptions(
      placeholder: nil,
      failureImage: UIImage(named: "empty_image_bottle")?.withTintColor(.blueGray),
      contentModes: nil,
      tintColors: nil)
    options.transition = .fadeIn(duration: 0.25)
    let request = ImageRequest(
      url: url,
      processors: [],
      cachePolicy: .default,
      priority: .high)

    Nuke.loadImage(with: request, options: options, into: self, completion: nil)
  }

  func loadImage(url: URL?) {
    guard let url = url else {
      return
    }
    
    ImageCache.shared.ttl = 30 * 24 * 60 * 60

    var options = ImageLoadingOptions(
      placeholder: nil,
      failureImage: nil,
      contentModes: nil,
      tintColors: nil)
    options.transition = .fadeIn(duration: 0.25)
    let request = ImageRequest(
      url: url,
      processors: [],
      cachePolicy: .default,
      priority: .high)

    Nuke.loadImage(with: request, options: options, into: self, completion: nil)
  }

}

public func prefetch(url: URL?) {
  guard let url = url else { return }
  let preheater = ImagePreheater(destination: .diskCache)
  preheater.startPreheating(with: [url])
}
