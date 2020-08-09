//
//  MoreInteractor.swift
//  Coffee
//
//  Created by Алексей Смирнов on 10/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//

import EmailService
import StringFormatting

protocol MoreInteractorProtocol: AnyObject {
    func sendEmail(HTMLText: String?)
}

final class MoreInteractor {
    
    weak var presenter: MorePresenterProtocol!
    let emailService: EmailServiceProtocol = EmailService()

    required init(presenter: MorePresenterProtocol) {
        self.presenter = presenter
    }
}

extension MoreInteractor: MoreInteractorProtocol {
    func sendEmail(HTMLText: String?) {
        if emailService.canSend {
            let mail = emailService.getEmailController(HTMLText: HTMLText, recipients: [localized("contact_email")])
            presenter.present(controller: mail, completion: nil)
        } else {
            presenter.showAlert(message: "Возникла ошибка при открытии почты") // TODO: - localized
        }
    }
}
