//
//  MoreViewControllerModel.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 12/9/20.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

import CommonUI

struct MoreViewControllerModel {

  enum Section {
    case contact([ContactCellViewModel])
    case rate([RateAppCellViewModel])
    case social([StandartImageViewModel])
    case doc([DocCellViewModel])
  }
  
  let sections: [Section]
}
