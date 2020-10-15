//___FILEHEADER___

import UIKit

final class ___VARIABLE_productName___ViewController: UIViewController {

    var interactor: ___VARIABLE_productName___InteractorProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
}

// MARK: - ___VARIABLE_productName___ViewControllerProtocol

extension ___VARIABLE_productName___ViewController: ___VARIABLE_productName___ViewControllerProtocol {

}
