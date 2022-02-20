//
//  MoreViewControllerModel.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 12/9/20.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import DisplayMini

struct MoreViewControllerModel {
  enum Section {
    case profile([ProfileCellViewModel])
    case header([TextCollectionCell.ViewModel])
    case phone([ContactCellViewModel])
    case email([ContactCellViewModel])
    case partner([ContactCellViewModel])
    case rate([RateAppCellViewModel])
    case orders([DocCellViewModel])
    case social([StandartImageViewModel])
    case currency([InfoCurrencyCellViewModel])
    case aboutApp([DocCellViewModel])
    case myStores([DocCellViewModel])
    case doc([DocCellViewModel])
    case separator
    case logout([LogOutCellViewModel])
  }

  let sections: [Section]
  let navigationTitle: String?
}
