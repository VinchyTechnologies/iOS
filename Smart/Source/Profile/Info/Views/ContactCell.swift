//
//  ContactCell.swift
//  Coffee
//
//  Created by Алексей Смирнов on 11/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//

import UIKit
import Display

final class ContactCell: UITableViewCell {
    
    private let contactImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .dark
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.dinAlternateBold(18)
        label.textColor = .dark
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.bold(12)
        label.textColor = .blueGray
        return label
    }()
            
    init(icon: UIImage, text: String, detailText: String) {
        super.init(style: .default, reuseIdentifier: nil)

        selectionStyle = .none

        contactImageView.image = icon.withRenderingMode(.alwaysTemplate)
        bodyLabel.text = text
        detailLabel.text = detailText
        
        addSubview(contactImageView)
        NSLayoutConstraint.activate([
            contactImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contactImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            contactImageView.widthAnchor.constraint(equalToConstant: 20),
            contactImageView.heightAnchor.constraint(equalToConstant: 20)
        ])

        addSubview(bodyLabel)
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: topAnchor, constant: 13),
            bodyLabel.leadingAnchor.constraint(equalTo: contactImageView.trailingAnchor, constant: 30),
        ])
        
        addSubview(detailLabel)
        NSLayoutConstraint.activate([
            detailLabel.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 4),
            detailLabel.leadingAnchor.constraint(equalTo: contactImageView.trailingAnchor, constant: 30),
            detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            detailLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
