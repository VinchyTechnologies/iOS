//
//  SectionMargin+ActionSheet.swift
//  Sheeeeeeeeet
//
//  Created by Daniel Saidi on 2019-09-24.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import UIKit

extension SectionMargin {

    open override func actionSheetCell(for tableView: UITableView) -> ActionSheetItemCell {
        ActionSheetSectionMarginCell(style: actionSheetCellStyle)
    }
    
    open override var actionSheetCellType: ActionSheetItemCell.Type {
        ActionSheetSectionMarginCell.self
    }
}
