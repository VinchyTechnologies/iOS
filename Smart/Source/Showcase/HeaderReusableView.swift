//
//  HeaderReusableView.swift
//  ASUI
//
//  Created by Aleksei Smirnov on 18.04.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

public struct HeaderReusableViewModel: ViewModelProtocol {
  
  fileprivate let title: String?
  
  public init(title: String?) {
    self.title = title
  }
}

public final class HeaderReusableView: UICollectionReusableView, Reusable {
  
  private let label = UILabel()
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .mainBackground
    
    label.font = Font.bold(20)
    label.textColor = .blueGray
    
    label.frame = CGRect(x: 10, y: 0, width: frame.width - 20, height: frame.height)
    addSubview(label)
  }
  
  required init?(coder: NSCoder) { fatalError() }
}

extension HeaderReusableView: Decoratable {
  
  public typealias ViewModel = HeaderReusableViewModel
  
  public func decorate(model: ViewModel) {
    label.text = model.title
  }
}
