//
//  URLImageNode.swift
//  LocationUI
//
//  Created by Aleksei Smirnov on 18.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AsyncDisplayKit
import Display

public struct URLImageNodeViewModel: ViewModelProtocol {

    public let url: String

    public init(url: String) {
        self.url = url
    }
}

public final class URLImageNode: ASDisplayNode {

    let urlImageView = URLImageView()

    lazy var node = ASDisplayNode(viewBlock: { () -> UIView in
        self.urlImageView
    })

    public override init() {
        super.init()
        addSubnode(node)
    }

    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        ASInsetLayoutSpec(insets: .zero, child: node)
    }
}

extension URLImageNode: Decoratable {

    public typealias ViewModel = URLImageNodeViewModel

    public func decorate(model: ViewModel) {
        urlImageView.render(url: model.url)
    }
}
