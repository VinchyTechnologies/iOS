//
//  ShowcaseInteractorProtocol.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/11/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

protocol ShowcaseInteractorProtocol {
  func viewDidLoad()
  func willDisplayLoadingView()
  func didSelectWine(wineID: Int64)
}
