//
//  URLImageView.swift
//  LocationUI
//
//  Created by Aleksei Smirnov on 18.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

private let config: URLSessionConfiguration = {
  let c = URLSessionConfiguration.ephemeral
  c.urlCache = ImageURLCache.current
  c.protocolClasses = [
    MapURLProtocol.self,
  ]
  return c
}()

private let session = URLSession(
  configuration: config,
  delegate: nil,
  delegateQueue: nil)

// MARK: - URLImageView

final class URLImageView: UIImageView, URLSessionDataDelegate {

  // MARK: Internal

  var task: URLSessionDataTask?
  var taskId: Int?

  func prepareForReuse() {
    task?.cancel()
    taskId = nil
    image = nil
  }

  func didLoadRemote(image: UIImage) {
    DispatchQueue.main.async {
      self.image = image
    }
  }

  func render(url: String) {
    assert(task == nil || task?.taskIdentifier != taskId)
    if let url = URL(string: url) {
      var id: Int?

      let request = URLRequest(
        url: url,
        cachePolicy: .returnCacheDataElseLoad,
        timeoutInterval: 30)

      task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
        self?.complete(taskId: id, data: data, response: response, error: error)
      })

      id = task?.taskIdentifier
      taskId = id
      task?.resume()
    }
  }

  // MARK: Private

  private func complete(taskId: Int?, data: Data?, response _: URLResponse?, error _: Error?) {
    if
      self.taskId == taskId,
      let data = data,
      let image = UIImage(data: data, scale: UIScreen.main.scale)
    {
      didLoadRemote(image: image)
    }
  }
}

// MARK: - ImageURLCache

final class ImageURLCache: URLCache {

  // MARK: Lifecycle

  override init() {
    let MB = 1024 * 1024
    super.init(
      memoryCapacity: 2 * MB,
      diskCapacity: 100 * MB,
      diskPath: "imageCache")
  }

  // MARK: Public

  override public func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
    ImageURLCache.accessQueue.sync {
      super.cachedResponse(for: request)
    }
  }

  override public func storeCachedResponse(_ response: CachedURLResponse, for request: URLRequest) {
    ImageURLCache.accessQueue.sync {
      super.storeCachedResponse(response, for: request)
    }
  }

  // MARK: Internal

  static var current = ImageURLCache()

  // MARK: Private

  private static let accessQueue = DispatchQueue(
    label: "image-urlcache-access"
  )
}
