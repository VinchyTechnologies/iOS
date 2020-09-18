//
//  AdvancedHeader.swift
//  Smart
//
//  Created by Aleksei Smirnov on 11.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

protocol AdvancedHeaderDelegate: AnyObject {
    func didTapHeader(at section: Int)
}

struct AdvancedHeaderViewModel: ViewModelProtocol {

    fileprivate let titleText: String?
    fileprivate let moreText: String?
    fileprivate let shouldShowMore: Bool

    init(titleText: String?, moreText: String?, shouldShowMore: Bool) {
        self.titleText = titleText
        self.moreText = moreText
        self.shouldShowMore = shouldShowMore
    }
}

final class AdvancedHeader: UICollectionReusableView, Reusable {

    private let titleLabel = UILabel()
    private let moreLabel = UILabel()

    var section: Int = 0

    weak var delegate: AdvancedHeaderDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
        addGestureRecognizer(tap)

        moreLabel.font = Font.medium(16)
        moreLabel.textColor = .accent

        addSubview(moreLabel)
        moreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            moreLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        titleLabel.font = Font.bold(22)
        titleLabel.textColor = .dark

        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: moreLabel.leadingAnchor, constant: -5),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    @objc
    private func didTapHeader() {
        if !moreLabel.isHidden {
            delegate?.didTapHeader(at: section)
        }
    }

}

extension AdvancedHeader: Decoratable {

    typealias ViewModel = AdvancedHeaderViewModel

    func decorate(model: ViewModel) {
        titleLabel.text = model.titleText
        moreLabel.text = model.moreText
        moreLabel.isHidden = !model.shouldShowMore
    }
}
