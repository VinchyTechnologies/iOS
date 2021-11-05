import Foundation
import UIKit

// MARK: - PagingMenuItemSource

public enum PagingMenuItemSource {
  case `class`(type: PagingCell.Type)
  case nib(nib: UINib)
}

// MARK: Equatable

extension PagingMenuItemSource: Equatable {
  public static func == (lhs: PagingMenuItemSource, rhs: PagingMenuItemSource) -> Bool {
    switch (lhs, rhs) {
    case (.class(let lhsType), .class(let rhsType)):
      return lhsType == rhsType

    case (.nib(let lhsNib), .nib(let rhsNib)):
      return lhsNib === rhsNib

    default:
      return false
    }
  }
}
