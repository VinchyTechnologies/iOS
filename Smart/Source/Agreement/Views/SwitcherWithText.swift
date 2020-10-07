//
//  SwitcherWithText.swift
//  Smart
//
//  Created by Aleksei Smirnov on 22.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

struct SwitcherWithTextViewModel: ViewModelProtocol {

    fileprivate let attributedText: NSAttributedString

    init(attributedText: NSAttributedString) {
        self.attributedText = attributedText
    }
}

final class SwitcherWithText: UIView {

    private(set) var label = UILabel()
    private(set) var switcher = UISwitch()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .horizontal)

        switcher.setContentCompressionResistancePriority(.required, for: .horizontal)
        switcher.onTintColor = .accent

        let stackView = UIStackView(arrangedSubviews: [
            label,
            switcher,
        ])
        
        stackView.distribution = .equalSpacing
        stackView.setCustomSpacing(20, after: label)
        stackView.axis = .horizontal

        addSubview(stackView)
        stackView.fill()

    }

    required init?(coder: NSCoder) { fatalError() }

}

extension SwitcherWithText: Decoratable {

    typealias ViewModel = SwitcherWithTextViewModel

    func decorate(model: ViewModel) {
        self.label.attributedText = model.attributedText
    }
}
