//
//  MainView.swift
//  Smart
//
//  Created by Aleksei Smirnov on 27.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import SwiftUI

final class ObjModel: ObservableObject {
    
    @Published var value: String = "1"

    init(value: String) {
        self.value = value
    }
}

struct MainView: View {

    @ObservedObject var string: ObjModel

    init(obj: ObjModel) {
        self.string = obj
    }

    var rowsModel: [MainCommonRow] = testData

    var body: some View {
        List {
            ForEach(rowsModel) { model in
                CommonCell(row: model)
            }
            .listRowInsets(EdgeInsets())
        }
    }

//        Text(string.value)

}

struct CommonCell: View {

    let row: MainCommonRow

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

//            Text(row.items.first?.title ?? "")
//                .font(.custom("DINAlternate-Bold", size: 30))
//                .padding(.all)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 15) {
                    ForEach(row.items, id: \.self) { item in
                        VStack(alignment: .leading, spacing: 10) {
                            Image(item.imageURL)
                                .resizable()
                                .aspectRatio(.init(width: 200, height: 200), contentMode: .fit)
                                .cornerRadius(CGFloat(item.cornerRadius))
                            Text(item.imageURL)
                                .font(.system(size: 20))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
            }
            .frame(height: CGFloat(row.rowHeight))
        }
    }
}

struct MainCommonRow: Identifiable {
    let id = UUID()
    let items: [MainCommonRowItem]
    let rowHeight: Int
}

struct MainCommonRowItem: Identifiable, Hashable {
    let id = UUID()
    let imageURL: String
    let title: String
    let cornerRadius: Int
}

let testData = [
    MainCommonRow(items: [
        MainCommonRowItem(imageURL: "Yoga", title: "Yoga", cornerRadius: 100),
        MainCommonRowItem(imageURL: "Yoga", title: "Yoga", cornerRadius: 100),
        MainCommonRowItem(imageURL: "Yoga", title: "Yoga", cornerRadius: 100)],
                  rowHeight: 200)
]

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView(string: $)
//    }
//}

struct JustAppearance {
    let items: [Appearance]
}

enum StackType {
    case v, h, z
}

struct Appearance {
    let stackType: StackType
    let stack: [SomeUIElement & Decodable]
}

protocol SomeUIElement { }

enum UIType: String, Decodable {
    case text
}

struct ASText: SomeUIElement, Decodable {

    var type: UIType = .text

    var settings: TextSettings

}

struct TextSettings: Decodable {
    let textColor: String
}


