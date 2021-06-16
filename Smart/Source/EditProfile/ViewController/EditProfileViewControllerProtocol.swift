//
//  EditProfileViewControllerProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 15.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol EditProfileViewControllerProtocol: AnyObject {
  func updateUI(viewModel: EditProfileViewModel)
  func setSaveButtonEnabled(_ flag: Bool)
}
