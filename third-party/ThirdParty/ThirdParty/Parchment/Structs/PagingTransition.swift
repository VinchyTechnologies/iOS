import UIKit

struct PagingTransition: Equatable {
  let contentOffset: CGPoint
  let distance: CGFloat

  static func == (lhs: PagingTransition, rhs: PagingTransition) -> Bool {
    lhs.contentOffset == rhs.contentOffset && lhs.distance == rhs.distance
  }
}
