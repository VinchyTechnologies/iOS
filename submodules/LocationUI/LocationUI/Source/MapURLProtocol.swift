//
//  MapURLProtocol.swift
//  LocationUI
//
//  Created by Aleksei Smirnov on 18.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import MapKit

final class MapURLProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        return request.url?.scheme == "map"
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    var thread: Thread!

    override func startLoading() {
        guard let url = request.url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems else {
                fail(with: .badURL)
                return
        }

        thread = Thread.current

        if let cachedResponse = cachedResponse {
            complete(with: cachedResponse)
        } else {
            load(with: queryItems)
        }
    }

    override func stopLoading() {
        isCancelled = true
    }

    var isCancelled: Bool = false

    func load(with queryItems: [URLQueryItem]) {
        let snapshotter = MKMapSnapshotter(queryItems: queryItems)
        snapshotter.start(
            with: DispatchQueue.global(qos: .background),
            completionHandler: handle
        )
    }

    func handle(snapshot: MKMapSnapshotter.Snapshot?, error: Error?) {
        thread.execute {
            if let snapshot = snapshot,
                let data = snapshot.image.jpegData(compressionQuality: 0.7) {
                self.complete(with: data)
            } else if let error = error {
                self.fail(with: error)
            }
        }
    }

    func complete(with cachedResponse: CachedURLResponse) {
        complete(with: cachedResponse.data)
    }

    func complete(with data: Data) {
        guard let url = request.url, let client = client else {
            return
        }

        let response = URLResponse(
            url: url,
            mimeType: "image/jpeg",
            expectedContentLength: data.count,
            textEncodingName: nil
        )

        client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        client.urlProtocol(self, didLoad: data)
        client.urlProtocolDidFinishLoading(self)
    }

    func fail(with errorCode: URLError.Code) {
        let error = URLError(errorCode, userInfo: [:])
        fail(with: error)
    }

    func fail(with error: Error) {
        client?.urlProtocol(self, didFailWithError: error)
    }
}

extension Thread {
    func dispatch(block: @escaping () -> Void) {
        if Thread.current == self {
            block()
        } else {
            perform(#selector(execute(block:)), on: self, with: block, waitUntilDone: false)
        }
    }

    @objc func execute(block: () -> Void) {
        block()
    }
}

extension MKMapSnapshotter.Options {
    public enum Key: String {
        case width = "width"
        case height = "height"
        case latitude = "latitude"
        case longitude = "longitude"
        case latitudeDelta = "latitude_delta"
        case longitudeDelta = "longitude_delta"
        case scale = "scale"
    }
}

extension MKMapSnapshotter.Options {
    public convenience init(items: [(Key, String?)]) {
        self.init()

        var width: CGFloat?
        var height: CGFloat?
        var lat: CLLocationDegrees?
        var lng: CLLocationDegrees?
        var latDelta: CLLocationDegrees?
        var lngDelta: CLLocationDegrees?
        var mapScale: CGFloat?

        func float(_ string: NSString) -> CGFloat {
            return CGFloat(string.floatValue)
        }

        for item in items {
            if let value = item.1 {
                let valueStr = NSString(string: value)
                switch item.0 {
                case .width:
                    width = float(valueStr)
                case .height:
                    height = float(valueStr)
                case .latitude:
                    lat = valueStr.doubleValue
                case .longitude:
                    lng = valueStr.doubleValue
                case .latitudeDelta:
                    latDelta = valueStr.doubleValue
                case .longitudeDelta:
                    lngDelta = valueStr.doubleValue
                case .scale:
                    mapScale = float(valueStr)
                }
            }
        }

        if let width = width, let height = height {
            size = CGSize(width: width, height: height)
        }

        if let lat = lat, let lng = lng, let latDelta = latDelta, let lngDelta = lngDelta {
            let center = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lngDelta)
            region = MKCoordinateRegion(center: center, span: span)
        }

        if let mapScale = mapScale {
            scale = mapScale
        }

    }
}

extension MKMapSnapshotter {
    convenience init(queryItems: [URLQueryItem]) {
        self.init(options: MKMapSnapshotter.options(from: queryItems))
    }

    static func options(from queryItems: [URLQueryItem]) -> MKMapSnapshotter.Options {
        return MKMapSnapshotter.Options(items: queryItems.compactMap({
            if let key = MKMapSnapshotter.Options.Key(rawValue: $0.name) {
                return (key, $0.value)
            } else {
                return nil
            }
        }))
    }
}

final class MapURLBuilder {
    func buildURL(latitude: CLLocationDegrees, longitude: CLLocationDegrees, size: CGSize) -> URL {
        func item(_ key: MKMapSnapshotter.Options.Key, _ value: String) -> URLQueryItem {
            return URLQueryItem(name: key.rawValue, value: value)
        }

        var components = URLComponents()
        components.scheme = "map"
        components.queryItems = [
            item(.width, String(describing: size.width)),
            item(.height, String(describing: size.height)),
            item(.latitude, String(latitude)),
            item(.longitude, String(longitude)),
            item(.latitudeDelta, String(0.003)),
            item(.longitudeDelta, String(0.003)),
            item(.scale, String(describing: UIScreen.main.scale))
        ]

        return components.url!
    }
}

fileprivate let builder = MapURLBuilder()

public func buildURL(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees, size: CGSize) -> String {
    builder.buildURL(latitude: latitude, longitude: longitude, size: size).absoluteString
}
