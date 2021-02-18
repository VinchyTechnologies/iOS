//
//  EnterPasswordPresenterProtocol.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 23.12.2020.
//

import Foundation

protocol EnterPasswordPresenterProtocol: AnyObject {
  func update()
  func updateButtonTitle(seconds: TimeInterval)
  func showAlertErrorWhileSendingCode(error: Error)
  func startLoading()
  func stopLoading()
}
