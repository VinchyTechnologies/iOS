//
//  DocumentsPresenterProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 04.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol DocumentsPresenterProtocol: AnyObject {
  func update(documents: [Document])
  func showAlertCantOpenURL()
}
