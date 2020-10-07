//
//  VinchyFooterCollectionReusableView.swift
//  Smart
//
//  Created by Aleksei Smirnov on 22.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

public struct VinchyFooterCollectionReusableViewModel: ViewModelProtocol {

    fileprivate let titleText: NSAttributedString?

    public init(titleText: NSAttributedString?) {
        self.titleText = titleText
    }
}

public final class VinchyFooterCollectionReusableView: UICollectionReusableView, Reusable {
    
    private let label = PaddingLabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        label.numberOfLines = 2
        label.insets = .init(top: 0, left: 20, bottom: 0, right: 20)
        addSubview(label)
    }

    required init?(coder: NSCoder) { fatalError() }

    public override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
}

extension VinchyFooterCollectionReusableView: Decoratable {

    public typealias ViewModel = VinchyFooterCollectionReusableViewModel

    public func decorate(model: ViewModel) {
        label.attributedText = model.titleText
    }
}
