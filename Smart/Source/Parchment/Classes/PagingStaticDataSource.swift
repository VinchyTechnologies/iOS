import Foundation
import UIKit

class PagingStaticDataSource: PagingViewControllerInfiniteDataSource {

  // MARK: Lifecycle

  init(viewControllers: [UIViewController]) {
    self.viewControllers = viewControllers
    reloadItems()
  }

  // MARK: Internal

  private(set) var items: [PagingItem] = []

  func pagingItem(at index: Int) -> PagingItem {
    items[index]
  }

  func reloadItems() {
    items = viewControllers.enumerated().map {
      PagingIndexItem(index: $0, title: $1.title ?? "")
    }
  }

  func pagingViewController(_: PagingViewController, viewControllerFor pagingItem: PagingItem) -> UIViewController {
    guard let index = items.firstIndex(where: { $0.isEqual(to: pagingItem) }) else {
      fatalError("pagingViewController:viewControllerFor: PagingItem does not exist")
    }
    return viewControllers[index]
  }

  func pagingViewController(_: PagingViewController, itemBefore pagingItem: PagingItem) -> PagingItem? {
    guard let index = items.firstIndex(where: { $0.isEqual(to: pagingItem) }) else { return nil }
    if index > 0 {
      return items[index - 1]
    }
    return nil
  }

  func pagingViewController(_: PagingViewController, itemAfter pagingItem: PagingItem) -> PagingItem? {
    guard let index = items.firstIndex(where: { $0.isEqual(to: pagingItem) }) else { return nil }
    if index < items.count - 1 {
      return items[index + 1]
    }
    return nil
  }

  // MARK: Private

  private let viewControllers: [UIViewController]

}
