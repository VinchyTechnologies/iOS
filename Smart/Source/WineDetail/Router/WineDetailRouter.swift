//
//  WineDetailRouter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Database
import VinchyCore
import EmailService

final class WineDetailRouter {

    weak var viewController: UIViewController?
    weak var interactor: WineDetailInteractorProtocol?
    private let input: WineDetailInput
    private let emailService = EmailService()

    init(
        input: WineDetailInput,
        viewController: UIViewController)
    {
        self.input = input
        self.viewController = viewController
    }
}

// MARK: - WineDetailRouterProtocol

extension WineDetailRouter: WineDetailRouterProtocol {

    func presentEmailController(HTMLText: String?, recipients: [String]) {

        let emailController = emailService.getEmailController(
            HTMLText: HTMLText,
            recipients: recipients)
        viewController?.present(emailController, animated: true, completion: nil)
    }

    func pushToWriteViewController(note: Note, subject: String?, body: String?) {

        let controller = WriteMessageController()

        controller.note = note
        controller.subject = note.title
        controller.body = note.fullReview

        controller.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }

    func pushToWriteViewController(wine: Wine) {

        let controller = WriteMessageController()
        controller.wine = wine
        controller.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }

    func presentActivityViewController(items: [Any]) {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        viewController?.present(controller, animated: true)
    }
}
