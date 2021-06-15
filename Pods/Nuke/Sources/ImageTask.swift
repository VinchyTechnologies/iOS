// The MIT License (MIT)
//
// Copyright (c) 2015-2021 Alexander Grebenyuk (github.com/kean).

import Foundation

#if !os(macOS)
import UIKit.UIImage
#else
import AppKit.NSImage
#endif

// MARK: - ImageTask

/// A task performed by the `ImagePipeline`. The pipeline maintains a strong
/// reference to the task until the request finishes or fails; you do not need
/// to maintain a reference to the task unless it is useful to do so for your
/// app’s internal bookkeeping purposes.
public /* final */ class ImageTask: Hashable, CustomStringConvertible {

  // MARK: Lifecycle

  deinit {
    self._isCancelled.deallocate()
    #if TRACK_ALLOCATIONS
    Allocations.decrement("ImageTask")
    #endif
  }

  init(taskId: Int64, request: ImageRequest, isDataTask: Bool) {
    self.taskId = taskId
    self.request = request
    _priority = request.priority
    priority = request.priority
    self.isDataTask = isDataTask

    _isCancelled = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
    _isCancelled.initialize(to: 0)

    #if TRACK_ALLOCATIONS
    Allocations.increment("ImageTask")
    #endif
  }

  // MARK: Public

  /// An identifier that uniquely identifies the task within a given pipeline. Only
  /// unique within that pipeline.
  public let taskId: Int64

  /// The original request with which the task was created.
  public let request: ImageRequest

  /// The number of bytes that the task has received.
  public internal(set) var completedUnitCount: Int64 = 0

  /// A best-guess upper bound on the number of bytes the client expects to send.
  public internal(set) var totalUnitCount: Int64 = 0

  /// Updates the priority of the task, even if the task is already running.
  public var priority: ImageRequest.Priority {
    didSet {
      pipeline?.imageTaskUpdatePriorityCalled(self, priority: priority)
    }
  }
  /// Returns a progress object for the task. The object is created lazily.
  public var progress: Progress {
    if _progress == nil { _progress = Progress() }
    return _progress!
  }
  // MARK: - CustomStringConvertible

  public var description: String {
    "ImageTask(id: \(taskId), priority: \(priority), completedUnitCount: \(completedUnitCount), totalUnitCount: \(totalUnitCount), isCancelled: \(isCancelled))"
  }

  public static func == (lhs: ImageTask, rhs: ImageTask) -> Bool {
    ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
  }

  /// Marks task as being cancelled.
  ///
  /// The pipeline will immediately cancel any work associated with a task
  /// unless there is an equivalent outstanding task running (see
  /// `ImagePipeline.Configuration.isDeduplicationEnabled` for more info).
  public func cancel() {
    if OSAtomicCompareAndSwap32Barrier(0, 1, _isCancelled) {
      pipeline?.imageTaskCancelCalled(self)
    }
  }

  // MARK: - Hashable

  public func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self).hashValue)
  }

  // MARK: Internal

  let isDataTask: Bool

  weak var pipeline: ImagePipeline?

  var _priority: ImageRequest.Priority // Backing store for access from pipeline

  private(set) var _progress: Progress?

  var isCancelled: Bool { _isCancelled.pointee == 1 }

  func setProgress(_ progress: TaskProgress) {
    completedUnitCount = progress.completed
    totalUnitCount = progress.total
    _progress?.completedUnitCount = progress.completed
    _progress?.totalUnitCount = progress.total
  }

  // MARK: Private

  private let _isCancelled: UnsafeMutablePointer<Int32>

}

// MARK: - ImageContainer

public struct ImageContainer {

  // MARK: Lifecycle

  public init(image: PlatformImage, type: ImageType? = nil, isPreview: Bool = false, data: Data? = nil, userInfo: [AnyHashable: Any] = [:]) {
    self.image = image
    self.type = type
    self.isPreview = isPreview
    self.data = data
    self.userInfo = userInfo
  }

  // MARK: Public

  public var image: PlatformImage
  public var type: ImageType?
  /// Returns `true` if the image in the container is a preview of the image.
  public var isPreview: Bool
  /// Contains the original image `data`, but only if the decoder decides to
  /// attach it to the image.
  ///
  /// The default decoder (`ImageDecoders.Default`) attaches data to GIFs to
  /// allow to display them using a rendering engine of your choice.
  ///
  /// - note: The `data`, along with the image container itself gets stored in the memory
  /// cache.
  public var data: Data?
  public var userInfo: [AnyHashable: Any]

  /// Modifies the wrapped image and keeps all of the rest of the metadata.
  public func map(_ closure: (PlatformImage) -> PlatformImage?) -> ImageContainer? {
    guard let image = closure(self.image) else {
      return nil
    }
    return ImageContainer(image: image, type: type, isPreview: isPreview, data: data, userInfo: userInfo)
  }
}

// MARK: - ImageResponse

/// Represents a response of a particular image task.
public final class ImageResponse {

  // MARK: Lifecycle

  @available(*, deprecated, message: "Please use `ImageResponse.init(container:urlResponse:)` instead.") // Deprecated in Nuke 9.0
  public init(image: PlatformImage, urlResponse: URLResponse? = nil, scanNumber: Int? = nil) {
    container = ImageContainer(image: image)
    self.urlResponse = urlResponse
    _scanNumber = scanNumber
  }

  public init(container: ImageContainer, urlResponse: URLResponse? = nil) {
    self.container = container
    self.urlResponse = urlResponse
    _scanNumber = nil
  }

  // MARK: Public

  public let container: ImageContainer
  public let urlResponse: URLResponse?

  /// A convenience computed property which returns an image from the container.
  public var image: PlatformImage { container.image }
  // the response is only nil when new disk cache is enabled (it only stores
  // data for now, but this might change in the future).
  @available(*, deprecated, message: "Please use `container.userInfo[ImageDecoders.Default.scanNumberKey]` instead.") // Deprecated in Nuke 9.0
  public var scanNumber: Int? {
    if let number = _scanNumber {
      return number // Deprecated version
    }
    return container.userInfo[ImageDecoders.Default.scanNumberKey] as? Int
  }

  // MARK: Internal

  func map(_ transformation: (ImageContainer) -> ImageContainer?) -> ImageResponse? {
    autoreleasepool {
      guard let output = transformation(container) else {
        return nil
      }
      return ImageResponse(container: output, urlResponse: urlResponse)
    }
  }

  // MARK: Private

  private let _scanNumber: Int?

}
