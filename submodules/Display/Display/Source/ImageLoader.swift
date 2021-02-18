//
//  ImageLoader.swift
//  Display
//
//  Created by Aleksei Smirnov on 05.12.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Nuke

final public class ImageLoader {
  
  public static let shared = ImageLoader()
  
  private let preheater = ImagePreheater()
  
  private init() {
    ImageCache.shared.ttl = 7 * 24 * 60 * 60
//    ImageCache.shared.countLimit = 1000
//    ImageCache.shared.costLimit = 200 * 1024 * 1024
//    DataLoader.sharedUrlCache.diskCapacity = 0
//    DataLoader.sharedUrlCache.memoryCapacity = 100
  }
  
  fileprivate func loadBottle(url: URL, imageView: UIImageView) {
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

    Nuke.loadImage(with: request, options: options, into: imageView, completion: nil)
  }
  
  fileprivate func loadCommonImage(url: URL, imageView: UIImageView) {
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

    Nuke.loadImage(with: request, into: imageView)
  }
  
  public func prefetch(url: URL?) {
    guard let url = url else {
      return
    }
    preheater.startPreheating(with: [url])
  }
}

public extension UIImageView {

  func loadBottle(url: URL?) {
    guard let url = url else {
      return
    }
    ImageLoader.shared.loadBottle(url: url, imageView: self)
  }

  func loadImage(url: URL?) {
    guard let url = url else {
      return
    }
    ImageLoader.shared.loadCommonImage(url: url, imageView: self)
  }
}

public func prefetch(url: URL?) {
  guard let url = url else { return }
  ImageLoader.shared.prefetch(url: url)
}
