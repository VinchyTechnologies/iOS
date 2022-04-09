//
//  SpotlightService.swift
//  Spotlight
//
//  Created by Алексей Смирнов on 25.11.2021.
//

import Core
import CoreSpotlight
import MobileCoreServices

// MARK: - SpotlightService

public final class SpotlightService {

  // MARK: Public

  public static let shared = SpotlightService()

  public func configure() {
    let dateFormatter = DateFormatter()

    if UserDefaultsConfig.spotlightUpdateDate == "" {
      CSSearchableIndex.default().deleteAllSearchableItems(completionHandler: nil)
      let spotlightUpdateDate = dateFormatter.string(from: Date())
      UserDefaultsConfig.spotlightUpdateDate = spotlightUpdateDate
    } else {
      if let date = dateFormatter.date(from: UserDefaultsConfig.spotlightUpdateDate) {
        if Date().days(from: date) > 7 {
          CSSearchableIndex.default().deleteAllSearchableItems(completionHandler: nil)
          let spotlightUpdateDate = dateFormatter.string(from: Date())
          UserDefaultsConfig.spotlightUpdateDate = spotlightUpdateDate
        }
      } else {
        CSSearchableIndex.default().deleteAllSearchableItems(completionHandler: nil)
        let spotlightUpdateDate = dateFormatter.string(from: Date())
        UserDefaultsConfig.spotlightUpdateDate = spotlightUpdateDate }
    }
  }

  public func addStore(affilatedId: Int, title: String, subtitle: String?) {
    let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeData as String)

    let identifier = "https://vinchy.tech/stores?id=\(affilatedId)"
    attributeSet.identifier = identifier
    attributeSet.title = title
    attributeSet.contentDescription = subtitle
    attributeSet.keywords = [title]
    attributeSet.addedDate = Date()

    let searchableItem = CSSearchableItem(uniqueIdentifier: identifier, domainIdentifier: "tech.vinchy.spotlight", attributeSet: attributeSet)

    add(items: [searchableItem])
  }

  // MARK: Private

  private func add(items: [CSSearchableItem]) {
    CSSearchableIndex.default().indexSearchableItems(items, completionHandler: nil)
  }
}

extension Date {
  fileprivate func days(from date: Date) -> Int {
    Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
  }
}
