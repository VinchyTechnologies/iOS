//
//  EditProfileInteractorProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 15.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol EditProfileInteractorProtocol: AnyObject {
  func viewDidLoad()
  func textFieldDidChanged(type: EditProfileTextFieldType, newValue: String?)
  func didTapSaveButton()
}
