//
//  Example
//  man.li
//
//  Created by man.li on 11/11/2018.
//  Copyright © 2020 man.li. All rights reserved.
//

import UIKit

// MARK: - CocoaDebugViewController

class CocoaDebugViewController: UIViewController {

  var bubble = Bubble(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: Bubble.size))

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    view.addSubview(bubble)
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    bubble.updateOrientation(newSize: size)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    bubble.center = Bubble.originalPosition
    bubble.delegate = self
    view.backgroundColor = .clear
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    WindowHelper.shared.displayedList = false
  }

  func shouldReceive(point: CGPoint) -> Bool {
    if WindowHelper.shared.displayedList {
      return true
    }
    return bubble.frame.contains(point)
  }
}

// MARK: BubbleDelegate

//MARK: - BubbleDelegate
extension CocoaDebugViewController: BubbleDelegate {

  func didTapBubble() {
    WindowHelper.shared.displayedList = true
    let storyboard = UIStoryboard(name: "Manager", bundle: Bundle(for: CocoaDebug.self))
    guard let vc = storyboard.instantiateInitialViewController() else {return}
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true, completion: nil)
  }
}
