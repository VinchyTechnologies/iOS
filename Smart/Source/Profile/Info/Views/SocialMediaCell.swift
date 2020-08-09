//
//  SocialMediaCell.swift
//  Coffee
//
//  Created by Алексей Смирнов on 11/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//

import UIKit
import Display
import StringFormatting

final class StandartImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}

protocol SocialMediaCellDelegate: AnyObject {
    func didClickVK()
    func didClickInstagram()
}

final class SocialMediaCell: UITableViewCell {

    weak var delegate: SocialMediaCellDelegate?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.bold(20)
        label.text = localized("we_are_in_social_networks").firstLetterUppercased()
        label.textColor = .dark
        
        return label
    }()
    
    private let vk = StandartImageView(image: UIImage(named: "vk3")!.withRenderingMode(.alwaysTemplate))
    
    private let instagram = StandartImageView(image: UIImage(named: "inst2")!.withRenderingMode(.alwaysTemplate))

    init(delegate: SocialMediaCellDelegate) {
        super.init(style: .default, reuseIdentifier: nil)
        self.delegate = delegate
        
        selectionStyle = .none
        
        let tapVK = UITapGestureRecognizer(target: self, action: #selector(actionVK))
        vk.addGestureRecognizer(tapVK)
        
        let tapInstagram = UITapGestureRecognizer(target: self, action: #selector(actionInstagram))
        instagram.addGestureRecognizer(tapInstagram)
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        vk.tintColor = .dark
        instagram.tintColor = .dark
        
        vk.heightAnchor.constraint(equalToConstant: 80).isActive = true
        instagram.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        vk.isUserInteractionEnabled = true
        instagram.isUserInteractionEnabled = true
        isUserInteractionEnabled = true
        
        let stackView = UIStackView(arrangedSubviews: [vk, instagram])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.isUserInteractionEnabled = true
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
        
    @objc private func actionVK() {
        delegate?.didClickVK()
    }
    
    @objc private func actionInstagram() {
        delegate?.didClickInstagram()
    }
}

