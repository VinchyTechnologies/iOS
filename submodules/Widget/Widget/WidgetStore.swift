//
//  WidgetStore.swift
//  Widget
//
//  Created by Алексей Смирнов on 21.01.2022.
//

public struct WidgetStore: Codable {
  public let id: Int
  public let imageURL: URL?
  public let title: String?
  public let subtitle: String?

  public init(id: Int, imageURL: URL?, title: String?, subtitle: String?) {
    self.id = id
    self.imageURL = imageURL
    self.title = title
    self.subtitle = subtitle
  }
}
