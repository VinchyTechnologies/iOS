//
//  HeaderCollectionReusableView.swift
//  CommonUI
//
//  Created by Aleksei Smirnov on 22.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

public struct HeaderCollectionReusableViewModel: ViewModelProtocol {

    fileprivate let titleText: NSAttributedString?
    fileprivate let insets: UIEdgeInsets

    public init(titleText: NSAttributedString?, insets: UIEdgeInsets = .zero) {
        self.titleText = titleText
        self.insets = insets
    }
}

public final class HeaderCollectionReusableView: UICollectionReusableView, Reusable {

    private let label = PaddingLabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainBackground
        addSubview(label)
    }

    required init?(coder: NSCoder) { fatalError() }

    public override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
}

extension HeaderCollectionReusableView: Decoratable {

    public typealias ViewModel = HeaderCollectionReusableViewModel

    public func decorate(model: HeaderCollectionReusableViewModel) {
        label.insets = model.insets
        label.attributedText = model.titleText
    }
}
