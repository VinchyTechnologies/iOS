//
//  URLImageView.swift
//  LocationUI
//
//  Created by Aleksei Smirnov on 18.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

fileprivate let config: URLSessionConfiguration = {
    let c = URLSessionConfiguration.ephemeral
    c.urlCache = ImageURLCache.current
    c.protocolClasses = [
        MapURLProtocol.self
    ]
    return c
}()

fileprivate let session = URLSession(
    configuration: config,
    delegate: nil,
    delegateQueue: nil
)

final class URLImageView: UIImageView, URLSessionDataDelegate {
    var task: URLSessionDataTask? = nil
    var taskId: Int? = nil

    func prepareForReuse() {
        task?.cancel()
        taskId = nil
        image = nil
    }

    private func complete(taskId: Int?, data: Data?, response: URLResponse?, error: Error?) {
        if self.taskId == taskId,
            let data = data,
            let image = UIImage(data: data, scale: UIScreen.main.scale) {
            didLoadRemote(image: image)
        }
    }

    func didLoadRemote(image: UIImage) {
        DispatchQueue.main.async {
            self.image = image
        }
    }

    func render(url: String) {
        assert(task == nil || task?.taskIdentifier != taskId)
        if let url = URL(string: url) {
            var id: Int? = nil

            let request = URLRequest(
                url: url,
                cachePolicy: .returnCacheDataElseLoad,
                timeoutInterval: 30
            )

            task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
                self?.complete(taskId: id, data: data, response: response, error: error)
            })

            id = task?.taskIdentifier
            taskId = id
            task?.resume()
        }
    }
}

final class ImageURLCache: URLCache {
    static var current = ImageURLCache()

    override init() {
        let MB = 1024 * 1024
        super.init(
            memoryCapacity: 2 * MB,
            diskCapacity: 100 * MB,
            diskPath: "imageCache"
        )
    }

    private static let accessQueue = DispatchQueue(
        label: "image-urlcache-access"
    )

    public override func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        return ImageURLCache.accessQueue.sync {
            return super.cachedResponse(for: request)
        }
    }

    public override func storeCachedResponse(_ response: CachedURLResponse, for request: URLRequest) {
        ImageURLCache.accessQueue.sync {
            super.storeCachedResponse(response, for: request)
        }
    }
}
