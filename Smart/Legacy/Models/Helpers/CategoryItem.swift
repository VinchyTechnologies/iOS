//
//  CategoryItem.swift
//  StartUp
//
//  Created by Aleksei Smirnov on 18.04.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core

struct CategoryItem: Decodable {

    let title: String
    let wines: [Wine]

//    static func mock() -> [CategoryItem] {
//        return [
//            CategoryItem(title: "Акции", products: Wine.arrayMock),
//            CategoryItem(title: "France",
//                         products: [
//                            Bottle(id: "12",
//                                    mainImageUrl: "https://media.danmurphys.com.au/dmo/product/464845-1.png",
//                                    title: "Dom Perignion",
//                                    desc: "Burgundia",
//                                    price: 1200)])
//        ]
//    }
}
