//
//  AllWidgets.swift
//  WidgetExtension
//
//  Created by Алексей Смирнов on 20.01.2022.
//  Copyright © 2022 Aleksei Smirnov. All rights reserved.
//

import Database
import Intents
import SwiftUI
import Widget
import WidgetKit

// MARK: - AllWidgetsEntryPoint

@main
struct AllWidgetsEntryPoint {
  static func main() {
    AllWidgets.main()
  }
}

// MARK: - AllWidgets

struct AllWidgets: WidgetBundle {
  var body: some Widget {
    StoresWidget()
    // PromoWidget()
  }
}

// MARK: - StoresProvider

struct StoresProvider: IntentTimelineProvider {

  // MARK: Public

  public typealias Entry = SimpleEntry

  // MARK: Internal

  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), kind: .preview, stores: [], configuration: ConfigurationIntent())
  }

  func getSnapshot(
    for configuration: ConfigurationIntent,
    in context: Context,
    completion: @escaping (SimpleEntry) -> Void)
  {
    let entry = SimpleEntry(date: Date(), kind: .preview, stores: [], configuration: configuration)
    completion(entry)
  }

  func getTimeline(
    for configuration: ConfigurationIntent,
    in context: Context,
    completion: @escaping (Timeline<Entry>) -> Void)
  {
    let stores = WidgetStorage.shared.getWidgetStores().compactMap { store in
      Entry.Store(id: store.id, imageURL: store.imageURL, title: store.title)
    }
    let entry = Entry(date: Date(), kind: .normal, stores: stores, configuration: configuration)
    let timeline = Timeline(entries: [entry], policy: .never)
    completion(timeline)
  }
}

// MARK: - StoresWidget

struct StoresWidget: Widget {

  private let kind: String = "StoresWidget"

  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: StoresProvider()) { entry in
      StoresView(data: entry)
    }
    .supportedFamilies([.systemMedium])
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

// MARK: - SimpleEntry

struct SimpleEntry: TimelineEntry {
  struct Store: Identifiable {
    let id: Int
    let imageURL: URL?
    let title: String?
  }

  enum Kind {
    case preview, normal
  }

  var date: Date
  let kind: Kind
  let stores: [Store]
  let configuration: ConfigurationIntent
}

// MARK: - StoresView

struct StoresView: View {
  var data: StoresProvider.Entry

  var body: some View {
    if data.kind == .preview {
      Text("Preview")
    } else if data.stores.isEmpty {
      Text("Empty")
    } else {
      Text(data.stores.first?.title ?? "HUI")
    }
  }
}

// MARK: - StoresWidget_Previews

struct StoresWidget_Previews: PreviewProvider {
  static var previews: some View {
    StoresView(data: SimpleEntry(date: Date(), kind: .preview, stores: [], configuration: ConfigurationIntent()))
      .previewContext(WidgetPreviewContext(family: .systemMedium))
  }
}
