//
//  DefaultTitleTableCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.06.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

struct DefaultTitleTableCellViewModel: ViewModelProtocol {
    let title: String?
}

final class DefaultTitleTableCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        textLabel?.font = Font.regular(20)
    }

    required init?(coder: NSCoder) { fatalError() }

}

extension DefaultTitleTableCell : Reusable { }

extension DefaultTitleTableCell: Decoratable {

    typealias ViewModel = DefaultTitleTableCellViewModel

    func decorate(model: ViewModel) {
        textLabel?.text = model.title
    }
}
