//
//  EditProfilePresenterProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 15.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol EditProfilePresenterProtocol: AnyObject {
  func update(userName: String?, email: String)
  func setSaveButtonEnabled(_ flag: Bool)
}
