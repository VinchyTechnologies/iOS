//
//  AppBundle.swift
//  Core
//
//  Created by Aleksei Smirnov on 27.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

struct TopSecretPreferences: Decodable {

    let apiKey: String

    private enum CodingKeys: String, CodingKey {
        case apiKey = "API_KEY"
    }
}

func getTopSecretPreferences() -> TopSecretPreferences? {
    if  let path        = Bundle.main.path(forResource: "TopSecret", ofType: "plist"),
        let xml         = FileManager.default.contents(atPath: path),
        let preferences = try? PropertyListDecoder().decode(TopSecretPreferences.self, from: xml) {
        return preferences
    }

    return nil
}
