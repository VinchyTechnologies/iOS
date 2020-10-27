//
//  Sugar.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 18.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

public enum Sugar: String, Decodable {
  
  case dry
  case semiDry = "semi-dry"
  case semiSweet = "semi-sweet"
  case sweet
  case none
}
