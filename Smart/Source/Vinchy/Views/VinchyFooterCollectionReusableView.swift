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

    let title: NSAttributedString?

    public init(title: NSAttributedString?) {
        self.title = title
    }
}

public final class VinchyFooterCollectionReusableView: UICollectionReusableView, Reusable {
    
    private let label = PaddingLabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        label.numberOfLines = 2
        label.insets = .init(top: 0, left: 15, bottom: 0, right: 15)
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

    public func decorate(model: VinchyFooterCollectionReusableViewModel) {
        label.attributedText = model.title
    }
}

