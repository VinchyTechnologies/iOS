//___FILEHEADER___

import UIKit

final class ___VARIABLE_productName___Router {

    weak var viewController: UIViewController?
    weak var interactor: ___VARIABLE_productName___InteractorProtocol?
    private let input: ___VARIABLE_productName___Input

    init(
        input: ___VARIABLE_productName___Input,
        viewController: UIViewController)
    {
        self.input = input
        self.viewController = viewController
    }
}

// MARK: - ___VARIABLE_productName___RouterProtocol

extension ___VARIABLE_productName___Router: ___VARIABLE_productName___RouterProtocol {

}
