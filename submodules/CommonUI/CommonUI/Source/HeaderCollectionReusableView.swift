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

    let title: NSAttributedString?

    public init(title: NSAttributedString?) {
        self.title = title
    }
}

public final class HeaderCollectionReusableView: UICollectionReusableView, Reusable {

    public static var reuseId: String = description()

    private let label = UILabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
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
        label.attributedText = model.title
    }
}
