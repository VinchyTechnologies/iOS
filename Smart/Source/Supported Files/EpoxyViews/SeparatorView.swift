//
//  SeparatorView.swift
//  Smart
//
//  Created by Алексей Смирнов on 10.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

//import Epoxy
//
//// MARK: - SeparatorView
//
//final class SeparatorView: UIView, EpoxyableView {
//
//  // MARK: Lifecycle
//
//  init(style: Style) {
//    super.init(frame: .zero)
//    translatesAutoresizingMaskIntoConstraints = false
//
//    let line = UIView()
//    line.backgroundColor = .separator
//
//    addSubview(line)
//    line.translatesAutoresizingMaskIntoConstraints = false
//    NSLayoutConstraint.activate([
//      line.topAnchor.constraint(equalTo: topAnchor),
//      line.leadingAnchor.constraint(equalTo: leadingAnchor),
//      line.trailingAnchor.constraint(equalTo: trailingAnchor),
//      line.bottomAnchor.constraint(equalTo: bottomAnchor),
//      line.heightAnchor.constraint(equalToConstant: 0.2),
//    ])
//  }
//
//  required init?(coder: NSCoder) { fatalError() }
//
//  // MARK: Internal
//
//  struct Style: Hashable {
//
//  }
//
//  // MARK: ContentConfigurableView
//
//  typealias Content = Never?
//
//  func setContent(_ content: Content, animated: Bool) {
//  }
//}
