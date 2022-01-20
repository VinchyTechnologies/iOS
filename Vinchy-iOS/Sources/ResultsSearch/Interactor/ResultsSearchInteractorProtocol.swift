//
//  ResultsSearchInteractorProtocol.swift
//  Smart
//
//  Created by Михаил Исаченко on 23.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

protocol ResultsSearchInteractorProtocol: AnyObject {
  func viewWillAppear()
  func didSelectResultCell(wineID: Int64, title: String)
  func didEnterSearchText(_ searchText: String?)
}
