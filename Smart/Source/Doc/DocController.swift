//
//  DocController.swift
//  Coffee
//
//  Created by Алексей Смирнов on 12/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//

import UIKit
import Display
import StringFormatting
import Core

final class DocController: UITableViewController, OpenURLProtocol, Alertable {

  private enum Row: CaseIterable {
    case termsOfUse

    var title: String {
      switch self {
      case .termsOfUse:
        return localized("terms_of_use_doc")
      }
    }

    var url: String {
      switch self {
      case .termsOfUse:
        return localized("terms_of_use_url")
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.largeTitleDisplayMode = .never
    navigationItem.title = localized("legal_documents").firstLetterUppercased()
    tableView.tableFooterView = UIView()
    tableView.separatorInset = .zero
    tableView.register(StandartCell.self, forCellReuseIdentifier: StandartCell.reuseId)
  }
  
  func actionOpenUrl(urlString: String) {
    open(urlString: urlString) {
      showAlert(message: localized("open_url_error"))
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Row.allCases.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: StandartCell.reuseId) as? StandartCell {
      cell.configure(text: Row.allCases[safe: indexPath.row]?.title ?? "")
      return cell
    }
    return .init()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let urlString = Row.allCases[safe: indexPath.row]?.url else {
      return
    }
    actionOpenUrl(urlString: urlString)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    52
  }
}

final fileprivate class StandartCell: UITableViewCell, Reusable {
  
  private let label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Font.bold(16)
    label.textColor = .dark
    
    return label
  }()
  
  private let acessoryImageView = StandartImageView(image: #imageLiteral(resourceName: "fill1Copy"))
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    selectionStyle = .none
    
    addSubview(acessoryImageView)
    acessoryImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      acessoryImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      acessoryImageView.widthAnchor.constraint(equalToConstant: 6),
      acessoryImageView.heightAnchor.constraint(equalToConstant: 10),
      acessoryImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
    
    addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      label.trailingAnchor.constraint(equalTo: acessoryImageView.leadingAnchor, constant: -5),
      label.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
  
  func configure(text: String?) {
    label.text = text
  }
}
