//
//  WidgetStorage.swift
//  Widget
//
//  Created by Алексей Смирнов on 21.01.2022.
//

import WidgetKit

public final class WidgetStorage {

  public static let shared = WidgetStorage()

  public func save(stores: [WidgetStore]) {
    let encoder = JSONEncoder()
    guard let encoded = try? encoder.encode(stores) else { return }
    UserDefaults(suiteName: "group.tech.vinchy.widgetGroup")?.set(encoded, forKey: "widgetStores")
    if #available(iOSApplicationExtension 14.0, *) {
      WidgetCenter.shared.reloadAllTimelines()
    }
  }

  public func getWidgetStores() -> [WidgetStore] {
    guard let data = UserDefaults(suiteName: "group.tech.vinchy.widgetGroup")?.value(forKey: "widgetStores") as? Data else {
      return []
    }
    let decoder = JSONDecoder()
    guard let decoded = try? decoder.decode([WidgetStore].self, from: data) else { return [] }
    return decoded
  }
}
