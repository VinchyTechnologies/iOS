import Foundation
import UIKit

class PagingSizeCache {

  // MARK: Lifecycle

  init(options: PagingOptions) {
    self.options = options

    let didEnterBackground = UIApplication.didEnterBackgroundNotification
    let didReceiveMemoryWarning = UIApplication.didReceiveMemoryWarningNotification

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(applicationDidEnterBackground(notification:)),
      name: didEnterBackground,
      object: nil)

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(didReceiveMemoryWarning(notification:)),
      name: didReceiveMemoryWarning,
      object: nil)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: Internal

  var options: PagingOptions
  var implementsSizeDelegate: Bool = false
  var sizeForPagingItem: ((PagingItem, Bool) -> CGFloat?)?

  func clear() {
    sizeCache = [:]
    selectedSizeCache = [:]
  }

  func itemSize(for pagingItem: PagingItem) -> CGFloat {
    if let size = sizeCache[pagingItem.identifier] {
      return size
    } else {
      let size = sizeForPagingItem?(pagingItem, false)
      sizeCache[pagingItem.identifier] = size
      return size ?? options.estimatedItemWidth
    }
  }

  func itemWidthSelected(for pagingItem: PagingItem) -> CGFloat {
    if let size = selectedSizeCache[pagingItem.identifier] {
      return size
    } else {
      let size = sizeForPagingItem?(pagingItem, true)
      selectedSizeCache[pagingItem.identifier] = size
      return size ?? options.estimatedItemWidth
    }
  }

  // MARK: Private

  private var sizeCache: [Int: CGFloat] = [:]
  private var selectedSizeCache: [Int: CGFloat] = [:]

  @objc
  private func didReceiveMemoryWarning(notification _: NSNotification) {
    clear()
  }

  @objc
  private func applicationDidEnterBackground(notification _: NSNotification) {
    clear()
  }
}
