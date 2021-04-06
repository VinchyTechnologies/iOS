//
//  ShowcaseInteractorProtocol.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/11/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

protocol ShowcaseInteractorProtocol {
  func viewDidLoad()
  func willDisplayLoadingView()
  func didSelectWine(input: ShowcaseInput)
}
