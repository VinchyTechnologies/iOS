//
//  WriteNoteRoutable.swift
//  Smart
//
//  Created by Михаил Исаченко on 02.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Database
import Display
import VinchyCore

// MARK: - WriteNoteRoutable

protocol WriteNoteRoutable: AnyObject {
  var viewController: UIViewController? { get }

  func pushToWriteViewController(note: VNote)
  func presentWriteViewController(note: VNote)

  func pushToWriteViewController(wine: Wine)
  func presentWriteViewController(wine: Wine)
}

extension WriteNoteRoutable {
  func pushToWriteViewController(note: VNote) {
    let controller = Assembly.buildWriteNoteViewController(for: note)
    guard let navigationController = viewController?.navigationController else {
      presentWriteViewController(note: note)
      return
    }
    navigationController.pushViewController(controller, animated: true)
  }

  func pushToWriteViewController(wine: Wine) {
    let controller = Assembly.buildWriteNoteViewController(for: wine)
    guard let navigationController = viewController?.navigationController else {
      presentWriteViewController(wine: wine)
      return
    }
    navigationController.pushViewController(controller, animated: true)
  }

  func presentWriteViewController(wine: Wine) {
    let controller = Assembly.buildWriteNoteViewController(for: wine)
    let navigationController = VinchyNavigationController(rootViewController: controller)
    navigationController.modalPresentationStyle = .pageSheet
    UIApplication.topViewController()?.present(
      navigationController,
      animated: true,
      completion: nil)
  }

  func presentWriteViewController(note: VNote) {
    let controller = Assembly.buildWriteNoteViewController(for: note)
    let navigationController = VinchyNavigationController(rootViewController: controller)
    navigationController.modalPresentationStyle = .pageSheet
    UIApplication.topViewController()?.present(
      navigationController,
      animated: true,
      completion: nil)
  }
}
