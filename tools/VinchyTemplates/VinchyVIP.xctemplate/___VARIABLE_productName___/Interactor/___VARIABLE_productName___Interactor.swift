// ___FILEHEADER___

import Foundation

// MARK: - ___VARIABLE_productName___Interactor

final class ___VARIABLE_productName___Interactor {

  // MARK: Lifecycle

  init(
    router: ___VARIABLE_productName___RouterProtocol,
    presenter: ___VARIABLE_productName___PresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let router: ___VARIABLE_productName___RouterProtocol
  private let presenter: ___VARIABLE_productName___PresenterProtocol
}

// MARK: ___VARIABLE_productName___InteractorProtocol

extension ___VARIABLE_productName___Interactor: ___VARIABLE_productName___InteractorProtocol {
  func viewDidLoad() {}
}
