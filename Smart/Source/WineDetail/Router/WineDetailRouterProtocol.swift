//
//  WineDetailRouterProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Database
import VinchyCore

protocol WineDetailRouterProtocol: AnyObject {
    func presentActivityViewController(items: [Any])
    func pushToWriteViewController(note: Note, subject: String?, body: String?)
    func pushToWriteViewController(wine: Wine)
    func presentEmailController(HTMLText: String?, recipients: [String])
}
