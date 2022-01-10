//
//  WriteNoteRouterProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 30.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Database
import UIKit.UIView

protocol WriteNoteRouterProtocol: AnyObject {
  func dismiss()
  func showAlertYouDidntSaveNote(text: String?, titleText: String?, subtitleText: String?, okText: String?, cancelText: String?, barButtonItem: UIBarButtonItem?)
  func showAlertToDelete(note: VNote, titleText: String?, subtitleText: String?, okText: String?, cancelText: String?, barButtonItem: UIBarButtonItem?)
}
