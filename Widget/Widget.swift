//
//  Widget.swift
//  Widget
//
//  Created by Алексей Смирнов on 17.01.2022.
//  Copyright © 2022 Aleksei Smirnov. All rights reserved.
//

import Intents
import SwiftUI
import WidgetKit

// MARK: - Provider

struct Provider: IntentTimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: ConfigurationIntent())
  }

  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
    let entry = SimpleEntry(date: Date(), configuration: configuration)
    completion(entry)
  }

  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    var entries: [SimpleEntry] = []

    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = SimpleEntry(date: entryDate, configuration: configuration)
      entries.append(entry)
    }

    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

// MARK: - SimpleEntry

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationIntent
}

// MARK: - WidgetEntryView

struct WidgetEntryView: View {
  var entry: Provider.Entry

  var body: some View {
    Text(entry.date, style: .time)
  }
}

// MARK: - StoresWidget

@main
struct StoresWidget: Widget {
  let kind: String = "Widget"

  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      WidgetEntryView(entry: entry)
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

// MARK: - StoresWidget_Previews

struct StoresWidget_Previews: PreviewProvider {
  static var previews: some View {
    WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
