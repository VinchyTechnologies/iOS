//
//  ImageLoader.swift
//  Display
//
//  Created by Aleksei Smirnov on 05.12.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Nuke
import UIKit

// MARK: - ImageLoader

public final class ImageLoader {

  // MARK: Lifecycle

  private init() {
    ImageCache.shared.ttl = 7 * 24 * 60 * 60

    preheater = ImagePrefetcher(pipeline: .shared, destination: .memoryCache, maxConcurrentRequestCount: 4)
//    ImageCache.shared.countLimit = 1000
//    ImageCache.shared.costLimit = 200 * 1024 * 1024
//    DataLoader.sharedUrlCache.diskCapacity = 0
//    DataLoader.sharedUrlCache.memoryCapacity = 100
  }

  // MARK: Public

  public static let shared = ImageLoader()

  public func prefetch(url: URL?) {
    guard let url = url else {
      return
    }
    preheater.startPrefetching(with: [url])
  }

  public func prefetch(_ urls: [URL]) {
    assert(Thread.isMainThread)
    preheater.startPrefetching(with: urls)
  }

  public func cancelPrefetch(_ urls: [URL]) {
    assert(Thread.isMainThread)
    preheater.stopPrefetching(with: urls)
  }

  // MARK: Internal

  let preheater: ImagePrefetcher

  // MARK: Fileprivate

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

}

extension UIImageView {
  public func loadBottle(url: URL?) {
    guard let url = url else {
      return
    }
    load(url, failureImage: UIImage(named: "empty_image_bottle")?.withTintColor(.blueGray))
//    ImageLoader.shared.loadBottle(url: url, imageView: self)
  }

  public func loadImage(url: URL?) {
    guard let url = url else {
      return
    }
    load(url)
//    ImageLoader.shared.loadCommonImage(url: url, imageView: self)
  }

  public func load(_ url: URL?, size: CGSize? = nil, isPrepareForReuseEnabled: Bool = true, useFadeAnimation: Bool = true, failureImage: UIImage? = nil) {

    guard let url = url else {
      image = nil
      return
    }

    var processors: [ImageProcessing] = []

    if let size = size {
      processors.append(ImageProcessors.Resize(size: size))
    }

    var options = ImageLoadingOptions()
    if useFadeAnimation {
      options.transition = .fadeIn(duration: 0.25)
    }
    options.isPrepareForReuseEnabled = isPrepareForReuseEnabled
    options.failureImage = failureImage

    let imagePipeline = ImagePipeline {
      let sessionConfiguration = DataLoader.defaultConfiguration
      sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
      $0.dataLoader = DataLoader(configuration: sessionConfiguration)
      $0.isProgressiveDecodingEnabled = true
      $0.dataLoadingQueue.maxConcurrentOperationCount = 4
    }

    options.pipeline = imagePipeline

    let imageRequest = ImageRequest(url: url, processors: processors)

    Nuke.loadImage(with: imageRequest, options: options, into: self)
  }
}
