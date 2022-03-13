//
//  QRPresenter.swift
//  Questions
//
//  Created by Алексей Смирнов on 13.03.2022.
//

import StringFormatting
import VinchyCore

// MARK: - QRPresenter

final class QRPresenter {

  // MARK: Lifecycle

  init(viewController: QRViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: QRViewControllerProtocol?

}

// MARK: QRPresenterProtocol

extension QRPresenter: QRPresenterProtocol {

  func update(error: Error) {
    viewController?.updateUI(errorViewModel: .init(titleText: localized("error").firstLetterUppercased(), subtitleText: error.localizedDescription, buttonText: localized("reload").firstLetterUppercased()))
  }

  func update(partnerInfo: PartnerInfo, wineID: Int64) {
    var sections: [QRViewModel.Section] = []
    sections += [.logo(content: .init(title: partnerInfo.title, logoURL: partnerInfo.logoURL))]
    sections += [.address(content: .init(titleText: partnerInfo.address, isMapButtonHidden: true))]
    sections += [.title(content: "Покажите код при оплате")]
    sections += [.subtitle(content: "Чтобы получить скидку предьявите этот код продавцу/официанту")]
    sections += [.qr(content: .init(text: String(wineID)))]
    sections += [.title(content: String(wineID))]
    viewController?.updateUI(viewModel: .init(sections: sections))
  }

  func startLoading() {
    viewController?.addLoader()
    viewController?.startLoadingAnimation()
  }

  func stopLoading() {
    viewController?.stopLoadingAnimation()
  }
}
