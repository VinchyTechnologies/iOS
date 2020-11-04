//
//  DetailFilterController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 11.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

final class DetailFilterController: UIViewController {
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.frame = view.frame
    view.addSubview(collectionView)
  }
  
}
