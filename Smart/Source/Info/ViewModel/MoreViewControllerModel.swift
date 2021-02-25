//
//  MoreViewControllerModel.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 12/9/20.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//
import CommonUI

struct MoreViewControllerModel {

  enum Section {
    case profile([ProfileCellViewModel])
    case header([TextCollectionCell.ViewModel])
    case phone([ContactCellViewModel])
    case email([ContactCellViewModel])
    case partner([ContactCellViewModel])
    case rate([RateAppCellViewModel])
    case social([StandartImageViewModel])
    case aboutApp([DocCellViewModel])
    case doc([DocCellViewModel])
    case separator
  }
  
  let sections: [Section]
  let navigationTitle: String?
}
