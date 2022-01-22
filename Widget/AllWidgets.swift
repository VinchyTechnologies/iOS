//
//  AllWidgets.swift
//  WidgetExtension
//
//  Created by Алексей Смирнов on 20.01.2022.
//  Copyright © 2022 Aleksei Smirnov. All rights reserved.
//

import Combine
import Database
import DisplayMini
import Intents
import StringFormatting
import SwiftUI
import Widget
import WidgetKit

// MARK: - C

fileprivate class C {
  var bundle: Bundle {
    Bundle(for: type(of: self))
  }
}

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
    SimpleEntry(date: Date(), kind: .preview, stores: [], configuration: ConfigurationIntent(), widgetHeight: context.displaySize.height)
  }

  func getSnapshot(
    for configuration: ConfigurationIntent,
    in context: Context,
    completion: @escaping (SimpleEntry) -> Void)
  {
    let entry = SimpleEntry(date: Date(), kind: .preview, stores: [], configuration: configuration, widgetHeight: context.displaySize.height)
    completion(entry)
  }

  func getTimeline(
    for configuration: ConfigurationIntent,
    in context: Context,
    completion: @escaping (Timeline<Entry>) -> Void)
  {
    let stores = WidgetStorage.shared.getWidgetStores().compactMap { store in
      Entry.Store(id: store.id, imageURL: store.imageURL, title: store.title, subtitle: store.subtitle)
    }
    let entry = Entry(date: Date(), kind: .normal, stores: stores, configuration: configuration, widgetHeight: context.displaySize.height)
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
    .configurationDisplayName(localized("Widget.Title", bundle: C().bundle))
    .description(localized("Widget.Description", bundle: C().bundle))
  }
}

// MARK: - SimpleEntry

struct SimpleEntry: TimelineEntry {
  struct Store: Identifiable {
    let id: Int
    let imageURL: URL?
    let title: String?
    let subtitle: String?
  }

  enum Kind {
    case preview, normal
  }

  var date: Date
  let kind: Kind
  let stores: [Store]
  let configuration: ConfigurationIntent
  let widgetHeight: CGFloat

}

// MARK: - StoresView

struct StoresView: View {

  // MARK: Lifecycle

  init(data: StoresProvider.Entry) {
    self.data = data
    imageHeight = (data.widgetHeight - 8 - 8 - 8 - 8 - 1) / 2
  }

  // MARK: Internal

  let imageHeight: CGFloat
  var data: StoresProvider.Entry

  var body: some View {
    VStack(spacing: 0) {
      if data.kind == .preview {
        previewRow(title: localized("Widget.Preview.Title1", bundle: C().bundle), subtitle: localized("Widget.Preview.Subtitle", bundle: C().bundle))
          .padding(.top, 8)
          .padding(.bottom, 8)
        Divider()
          .frame(height: 1)
          .padding(.init(top: 0, leading: imageHeight + 16, bottom: 0, trailing: 0))
        previewRow(title: localized("Widget.Preview.Title2", bundle: C().bundle), subtitle: localized("Widget.Preview.Subtitle", bundle: C().bundle))
          .padding(.top, 8)
          .padding(.bottom, 8)

      } else if data.stores.isEmpty {
        HStack {
          VStack(alignment: .center, spacing: 8) {
            Text(localized("Widget.Description", bundle: C().bundle))
              .font(.system(size: 16, weight: .heavy, design: .default))
              .padding()
              .multilineTextAlignment(.center)
            Link(destination: URL(string: "vinchy://openSavedStoresInWidgetEditingMode")!) { // swiftlint:disable:this force_unwrapping
              Text(localized("Widget.Customize", bundle: C().bundle).firstLetterUppercased())
                .font(.system(size: 16, weight: .bold, design: .default))
                .foregroundColor(Color(.white))
                .frame(width: localized("Widget.Customize", bundle: C().bundle).firstLetterUppercased().width(usingFont: .systemFont(ofSize: 16, weight: .bold)) + 32, height: 48, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                .background(Color(.accent))
                .cornerRadius(24)
            }
            Spacer()
          }
          .background(Color(.mainBackground))
        }
        .frame(
          minWidth: 0,
          maxWidth: .infinity,
          minHeight: 0,
          maxHeight: .infinity,
          alignment: .center)
        .background(Color(.mainBackground))

      } else {
        if let store1 = data.stores.first, let url1 = URL(string: "https://vinchy.tech/store/\(store1.id)") {
          Link(destination: url1) {
            row(for: store1)
              .padding(.top, 8)
              .padding(.bottom, 8)
          }
        }
        Divider()
          .frame(height: 1)
          .padding(.init(top: 0, leading: imageHeight + 16, bottom: 0, trailing: 0))
        if let store2 = data.stores.last, data.stores.count == 2, let url2 = URL(string: "https://vinchy.tech/store/\(store2.id)") {
          Link(destination: url2) {
            row(for: store2)
              .padding(.top, 8)
              .padding(.bottom, 8)
          }
        } else {
          Spacer()
        }
      }
    }
    .background(Color(.mainBackground))
  }

  // MARK: Private

  private func row(for store: SimpleEntry.Store) -> some View {
    HStack(alignment: .center, spacing: 8) {
      if let url = store.imageURL, let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
        Image(uiImage: uiImage)
          .resizable()
          .clipShape(Circle())
          .frame(width: imageHeight, height: imageHeight)
      } else {
        Image("logo")
          .resizable()
          .clipShape(Circle())
          .frame(width: imageHeight, height: imageHeight)
      }
      VStack(alignment: .leading) {
        if let title = store.title {
          Text(title)
            .font(.system(size: 16, weight: .heavy, design: .default))
        }
        if let subtitle = store.subtitle {
          Text(subtitle)
            .font(.system(size: 14, weight: .regular, design: .default))
            .lineLimit(2)
            .foregroundColor(.secondary)
        }
      }
      .frame(height: imageHeight)
      Spacer()
    }
    .padding(.init(top: 0, leading: 8, bottom: 0, trailing: 8))
  }

  private func previewRow(title: String, subtitle: String) -> some View {
    HStack(alignment: .center, spacing: 8) {
      Image("logo")
        .resizable()
        .clipShape(Circle())
        .frame(width: imageHeight, height: imageHeight)
      VStack(alignment: .leading) {
        Text(title)
          .font(.system(size: 16, weight: .heavy, design: .default))
        Text(subtitle)
          .font(.system(size: 14, weight: .regular, design: .default))
          .lineLimit(2)
          .foregroundColor(.secondary)
      }
      .frame(height: imageHeight)
      Spacer()
    }
    .padding(.init(top: 0, leading: 8, bottom: 0, trailing: 8))
  }
}
