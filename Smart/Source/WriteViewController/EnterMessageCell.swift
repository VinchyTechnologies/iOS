//
//  EnterMessageCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 03.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

protocol EnterMessageCellDelegate: AnyObject {
    func handleEditing(title: String, fullReview: String?)
}

final class EnterMessageCell: UITableViewCell, UITextViewDelegate, Reusable {

    weak var delegate: EnterMessageCellDelegate?
    weak var tableView: UITableView?

    var labelPlaceholder: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 1
        label.font = Font.regular(16)
//        label.addCharacterSpacing(spacing: -0.4)
        label.textColor = .blueGray

        return label
    }()

    var textFieldTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        label.font = Font.regular(12)
//        label.addCharacterSpacing(spacing: 0.4)
        label.textColor = UIColor.rgb(red: 107, green: 114, blue: 128, alpha: 1)

        return label
    }()

    lazy var textField: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.alpha = 0
        textField.font = Font.dinAlternateBold(18)
        textField.textColor = .dark
        textField.delegate = self
        textField.isScrollEnabled = false
        textField.autocorrectionType = .no

        return textField
    }()

    let line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(red: 213, green: 217, blue: 224, alpha: 1)
        return view
    }()

    func cell(isSelected : Bool) {
        guard let text = textField.text else {return}
        if isSelected {
            UIView.animate(withDuration: 0.45) {
                self.labelPlaceholder.alpha = 0
                self.removeConstraint(self.labelPlaceholderBottomAnchor!)
                self.addConstraint(self.textFieldBottomAnchor!)
                self.textFieldTitle.alpha = 1
                self.textField.alpha = 1
            }
        } else {
            if text.count ==  0 {
                UIView.animate(withDuration: 0.45) {
                    self.labelPlaceholder.alpha = 1
                    self.removeConstraint(self.textFieldBottomAnchor!)
                    self.addConstraint(self.labelPlaceholderBottomAnchor!)
                    self.textFieldTitle.alpha = 0
                    self.textField.alpha = 0
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        guard let _ = textField.text else { return }
        cell(isSelected: selected)
    }

    private var textFieldBottomAnchor: NSLayoutConstraint?
    private var labelPlaceholderBottomAnchor: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        addSubview(labelPlaceholder)
        labelPlaceholder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        labelPlaceholder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        labelPlaceholder.topAnchor.constraint(equalTo: topAnchor, constant: 22).isActive = true
        labelPlaceholderBottomAnchor = NSLayoutConstraint(item: labelPlaceholder, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -26)
        addConstraint(labelPlaceholderBottomAnchor!)

        addSubview(textField)
        textField.heightAnchor.constraint(equalToConstant: 38).isActive = true
        textField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        textFieldBottomAnchor = NSLayoutConstraint(item: textField, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -11)
        textField.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true

        addSubview(textFieldTitle)
        NSLayoutConstraint.activate([
            textFieldTitle.heightAnchor.constraint(equalToConstant: 12),
            textFieldTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textFieldTitle.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            textFieldTitle.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -16),
            textFieldTitle.topAnchor.constraint(equalTo: topAnchor, constant: 15)
        ])

        addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            line.leadingAnchor.constraint(equalTo: leadingAnchor),
            line.trailingAnchor.constraint(equalTo: trailingAnchor),
            line.bottomAnchor.constraint(equalTo: bottomAnchor),
            line.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: frame.width - 44, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)

        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }

        if size.height != estimatedSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)

            if let thisIndexPath = tableView?.indexPath(for: self) {
                tableView?.scrollToRow(at: thisIndexPath, at: .bottom, animated: true)
            }
        }

        handleEditing()
    }

    @objc private func handleEditing() {
        guard
            let cell1 = tableView?.cellForRow(at: IndexPath(row: 0, section: 0)) as? EnterMessageCell,
            let cell2 = tableView?.cellForRow(at: IndexPath(row: 1, section: 0)) as? EnterMessageCell
        else {
            return
        }

        delegate?.handleEditing(title: cell1.textField.text, fullReview: cell2.textField.text)
    }
}
