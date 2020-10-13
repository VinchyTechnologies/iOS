//
//  VinchyViewControllerViewModel.swift
//  Smart
//
//  Created by Aleksei Smirnov on 08.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI

struct VinchyViewControllerViewModel {

    enum Section {
        case title([TextCollectionCellViewModel])
        case stories([VinchySimpleConiniousCaruselCollectionCellViewModel])
        case promo([VinchySimpleConiniousCaruselCollectionCellViewModel])
        case big([VinchySimpleConiniousCaruselCollectionCellViewModel])
        case bottles([VinchySimpleConiniousCaruselCollectionCellViewModel])
        case suggestions([SuggestionCollectionCellViewModel])
        case shareUs([ShareUsCollectionCellViewModel])
    }
}
