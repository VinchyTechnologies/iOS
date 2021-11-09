import Foundation
import UIKit

func tween(from: CGFloat, to: CGFloat, progress: CGFloat) -> CGFloat {
  ((to - from) * progress) + from
}
