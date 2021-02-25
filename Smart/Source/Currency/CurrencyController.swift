//
//  CurrencyController.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 2/22/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//
import UIKit
import Display
import StringFormatting
import Core

final class CurrencyController: UITableViewController {
  
  var userDefaults = UserDefaults.standard
  
  var selectedCurrency: String?
  
  let currencies = ["Dollar", "Ruble", "Euro"]
  
   override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.largeTitleDisplayMode = .never
    navigationItem.title = localized("currency").firstLetterUppercased()
    tableView.tableFooterView = UIView()
    tableView.separatorInset = .zero
    tableView.register(ValueCell.self, forCellReuseIdentifier: ValueCell.reuseId)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currencies.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: ValueCell.reuseId) as? ValueCell {
      let isSelected = selectedCurrency == currencies[indexPath.row]
      cell.configure(text: currencies[indexPath.row], isSelectes: isSelected)
      return cell
    }
    return .init()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedCurrency = currencies[indexPath.row]
    tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    52
  }
 
}

final fileprivate class ValueCell: UITableViewCell, Reusable {
  
  private let label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Font.bold(16)
    label.textColor = .dark
    
    return label
  }()

  private let customView: UIView = {
    let customView = UIView()
    customView.translatesAutoresizingMaskIntoConstraints = false
    customView.backgroundColor = .clear
    customView.layer.borderColor = UIColor.blueGray.cgColor
    customView.layer.borderWidth = 1
    customView.layer.cornerRadius = 15
    customView.clipsToBounds = true
    
    return customView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    selectionStyle = .none
    
    addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      label.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
    
    addSubview(customView)
    customView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      customView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
      customView.heightAnchor.constraint(equalToConstant: 30),
      customView.widthAnchor.constraint(equalToConstant: 30),
    ])
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
  
  func configure(text: String?, isSelectes: Bool) {
    label.text = text
    if isSelectes == true {
      customView.backgroundColor = .blueGray
    } else {
      customView.backgroundColor = .clear
    }
  }
}
