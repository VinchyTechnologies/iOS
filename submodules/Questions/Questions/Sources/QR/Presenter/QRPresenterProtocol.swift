//
//  QRPresenterProtocol.swift
//  Questions
//
//  Created by Алексей Смирнов on 13.03.2022.
//

import VinchyCore

protocol QRPresenterProtocol: AnyObject {
  func update(partnerInfo: PartnerInfo, wineID: Int64)
  func update(error: Error)
  func startLoading()
  func stopLoading()
}
