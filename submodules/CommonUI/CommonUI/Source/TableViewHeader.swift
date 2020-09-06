//
//  TableViewHeader.swift
//  CommonUI
//
//  Created by Aleksei Smirnov on 18.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

public struct TableViewHeaderViewModel: ViewModelProtocol {
    
    fileprivate let titleText: String?

    public init(titleText: String?) {
        self.titleText = titleText
    }
}

public final class TableViewHeader: UIView {

    private let titleLabel = UILabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.font = Font.medium(20)
        titleLabel.textColor = .blueGray
        addSubview(titleLabel)
    }

    required init?(coder: NSCoder) { fatalError() }

    public override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 20, y: 0, width: frame.width - 40, height: frame.height)
    }

}

extension TableViewHeader: Decoratable {

    public typealias ViewModel = TableViewHeaderViewModel

    public func decorate(model: ViewModel) {
        titleLabel.text = model.titleText
    }
}
