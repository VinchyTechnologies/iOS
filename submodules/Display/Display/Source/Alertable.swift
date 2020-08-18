//
//  Alertable.swift
//  Display
//
//  Created by Aleksei Smirnov on 09.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import StringFormatting

public protocol Alertable: UIViewController {
    func showAlert(title: String, message: String)
}

extension Alertable {
    public func showAlert(title: String = localized("error").firstLetterUppercased(), message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.view.tintColor = .accent
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
