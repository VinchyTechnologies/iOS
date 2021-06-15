// ___FILEHEADER___

import Foundation

// MARK: - ___VARIABLE_productName___Presenter

final class ___VARIABLE_productName___Presenter {

  // MARK: Lifecycle

  init(viewController: ___VARIABLE_productName___ViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: ___VARIABLE_productName___ViewControllerProtocol?

  // MARK: Private

  private typealias ViewModel = ___VARIABLE_productName___ViewModel
}

// MARK: ___VARIABLE_productName___PresenterProtocol

extension ___VARIABLE_productName___Presenter: ___VARIABLE_productName___PresenterProtocol {}
