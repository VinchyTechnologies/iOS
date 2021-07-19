//
//  SearchInteractorProtocol.swift
//  Smart
//
//  Created by Алексей Смирнов on 01.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol SearchInteractorProtocol: AnyObject {
  func viewWillAppear()
  func didTapSearchButton(searchText: String?)
  func didEnterSearchText(_ searchText: String?)
}
