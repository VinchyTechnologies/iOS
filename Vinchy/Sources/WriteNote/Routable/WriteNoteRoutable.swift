//
//  WriteNoteRoutable.swift
//  Smart
//
//  Created by Михаил Исаченко on 02.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Database
import DisplayMini
import UIKit
import VinchyCore
import VinchyUI

// MARK: - WriteNoteRoutable

extension WriteNoteRoutable {
  func presentWriteViewController(wine: Wine) {
    let controller = WriteNoteAssembly.assemblyModule(input: .init(wine: .firstTime(wine: wine)))
    let navigationController = VinchyNavigationController(rootViewController: controller)
    navigationController.modalPresentationStyle = .fullScreen
    UIApplication.topViewController()?.present(navigationController, animated: true)
  }

  func presentWriteViewController(note: VNote) {
    let controller = WriteNoteAssembly.assemblyModule(input: .init(wine: .database(note: note)))
    let navigationController = VinchyNavigationController(rootViewController: controller)
    navigationController.modalPresentationStyle = .fullScreen
    UIApplication.topViewController()?.present(navigationController, animated: true)
  }
}
