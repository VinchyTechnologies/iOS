//
//  OptionsInteractorProtocol.swift
//  Questions
//
//  Created by Алексей Смирнов on 12.03.2022.
//

import Foundation

protocol OptionsInteractorProtocol: AnyObject {
  func viewDidLoad()
  func viewWillAppear(dataSource: [Int: [Int]])
  func didSelectOption(id: Int)
  func didTapNextButton()
  func didTapClose()
}
