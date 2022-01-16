//
//  NotificationDebug.swift
//  NotificationsDebug
//
//  Created by Алексей Смирнов on 16.01.2022.
//

import SwiftUI

// MARK: - NotificationDebugView

public struct NotificationDebugView: View {

  // MARK: Lifecycle

  public init() {

  }

  // MARK: Public

  public var body: some View {
    if #available(iOS 14.0, *) {
      list
        .listStyle(.insetGrouped)
        .navigationTitle("Push Notifications Test")
    } else {
      list
        .listStyle(.grouped)
        .navigationBarTitle(Text("Push Notifications Test"))
    }
  }

  // MARK: Private

  @State private var titleText: String = ""
  @State private var bodyText: String = ""
  @State private var deviceToken: String = ""

  private var list: some View {
    List {
      Section {
        TextField("", text: $titleText)
      } header: {
        Text("Title")
      }

      Section {
        TextField("", text: $bodyText)
      } header: {
        Text("Body")
      }

      Section {
        TextField("", text: $deviceToken)
      } header: {
        Text("Device Token")
      }

      Button {
        sendPushNotification()
      } label: {
        Text("Send Push Notification")
      }
    }
  }

  private func sendPushNotification() {
    let url = URL(string: "https://fcm.googleapis.com/fcm/send")! // swiftlint:disable:this force_unwrapping

    let json: [String: Any] = [
      "to": deviceToken,
      "notification": [
        "title": titleText,
        "body": bodyText,
      ],
      "data": [
        "promo_id": "1",
      ],
    ]

    let serverKey = ""

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")

    let session = URLSession(configuration: .default)
    session.dataTask(with: request) { _, _, err in
      if let err = err {
        print(err)
        return
      }
      print("Success")
      DispatchQueue.main.async { [self] in
        titleText = ""
        bodyText = ""
        deviceToken = ""
      }
    }.resume()
  }
}

// MARK: - NotificationDebugView_Previews

struct NotificationDebugView_Previews: PreviewProvider {
  static var previews: some View {
    NotificationDebugView()
  }
}
