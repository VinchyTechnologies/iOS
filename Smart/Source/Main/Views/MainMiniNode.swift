//
//  RectangleNode.swift
//  Smart
//
//  Created by Aleksei Smirnov on 08.06.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AsyncDisplayKit
import Display

struct MainMiniNodeViewModel: ViewModelProtocol {

    let imageURL: String
    let title: String

    init(imageURL: String, title: String) {
        self.imageURL = imageURL
        self.title = title
    }
}

final class MainMiniNode: ASCellNode {

    // MARK: - Constants

    private enum Constants {
        static let titleNumberOfLines = 2
        static let titleLabelColor: UIColor = .white
        static let cornerRadius: CGFloat = 12
        static let titleLabelFont = Font.bold(14)
        static let titleLineHeightMultiple: CGFloat = 1.22
        static let width: CGFloat = 135
        static let titleInset: CGFloat = 12
    }

    // MARK: - Private Properties

    private let model: MainMiniNodeViewModel
    private let imageNode = ASNetworkImageNode()
    private let titleLabel = UILabel()

    // MARK: - Initializers

    init(_ model: MainMiniNodeViewModel) {
        self.model = model
        super.init()


        layer.cornerRadius = Constants.cornerRadius
        clipsToBounds = true
        backgroundColor = .mainColor
        style.width = .init(unit: .points, value: Constants.width)

        addSubnode(imageNode)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = Constants.titleNumberOfLines
        titleLabel.textColor = Constants.titleLabelColor
        titleLabel.font = Constants.titleLabelFont

        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.titleInset),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.titleInset),
            titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.titleInset)
        ])

        decorate(model: model)

    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: imageNode)
    }

    private func setAttributedText(string: String) {
        let attributedString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = Constants.titleLineHeightMultiple
        attributedString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSMakeRange(0, attributedString.length))

        titleLabel.attributedText = attributedString
    }

}

extension MainMiniNode : Decoratable {

    typealias ViewModel = MainMiniNodeViewModel

    func decorate(model: MainMiniNodeViewModel) {
        imageNode.setURL(URL(string: model.imageURL), resetToDefault: true)
        setAttributedText(string: model.title)
    }
}
