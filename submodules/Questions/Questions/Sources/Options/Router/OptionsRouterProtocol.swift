//
//  OptionsRouterProtocol.swift
//  Questions
//
//  Created by Алексей Смирнов on 12.03.2022.
//

import Foundation
import VinchyUI

protocol OptionsRouterProtocol: AnyObject {
  func pushToNextQuestion(selectedIds: [Int])
  func dismiss()
  func pushToShowcaseViewController(input: ShowcaseInput, selectedIds: [Int])
}
