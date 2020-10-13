//
//  VinchyViewControllerProtocol.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import VinchyCore
import Display

protocol VinchyViewControllerProtocol: Loadable, Alertable {
    func updateSearchSuggestions(suggestions: [Wine])
    func updateUI(sections: [VinchyViewControllerViewModel.Section])
    func updateUI(didFindWines: [Wine])
}
