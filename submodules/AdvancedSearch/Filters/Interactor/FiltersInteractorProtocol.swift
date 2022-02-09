//
//  FiltersInteractorProtocol.swift
//  AdvancedSearch
//
//  Created by Алексей Смирнов on 01.02.2022.
//

import DisplayMini

protocol FiltersInteractorProtocol: AnyObject {
  func viewDidLoad()
  func didSelect(item: ImageOptionView.Content)
  func isSelected(item: ImageOptionView.Content) -> Bool
  func didTapResetAllFilters()
  func didTapSeeAllCounties()
  func didChoose(countryCodes: [String])
  func didTapConfirmFilters()
  func didEnterMinMaxPrice(minPrice: Int?, maxPrice: Int?)
}
