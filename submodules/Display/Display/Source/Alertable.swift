//
//  Alertable.swift
//  Display
//
//  Created by Aleksei Smirnov on 09.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Combine
import StringFormatting

public protocol Alertable: UIViewController {
    @discardableResult
    func showAlert(title: String, message: String?) -> AnyPublisher<Void, Never>
}

extension Alertable {

    @discardableResult
    public func showAlert(title: String = localized("error").firstLetterUppercased(), message: String?) -> AnyPublisher<Void, Never> {

        return Future { resolve in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertController.view.tintColor = .accent
                alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    resolve(.success(()))
                })
                self.present(alertController, animated: true, completion: nil)
            }
        }
        .handleEvents(receiveCancel: {
            self.dismiss(animated: true)
        })
        .eraseToAnyPublisher()
    }
}
