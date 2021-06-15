// ___FILEHEADER___

import UIKit

// MARK: - ___VARIABLE_productName___Router

final class ___VARIABLE_productName___Router {

  // MARK: Lifecycle

  init(
    input: ___VARIABLE_productName___Input,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: ___VARIABLE_productName___InteractorProtocol?

  // MARK: Private

  private let input: ___VARIABLE_productName___Input
}

// MARK: ___VARIABLE_productName___RouterProtocol

extension ___VARIABLE_productName___Router: ___VARIABLE_productName___RouterProtocol {}
