//
//  ArmorComponent.swift
//  MHWDB
//
//  Created by Joe on 5/13/18.
//  Copyright © 2018 Gathering Hall Studios. All rights reserved.
//

import GRDB

class ArmorComponent: FetchableRecord, Decodable {
    var itemId: Int
    var name: String
    var type: String?
    var quantity: Int?
    var iconName: String?
    var iconColor: Icon.Color?

    var icon: Icon? {
        return Icon(name: iconName, color: iconColor)
    }

    enum CodingKeys: String, CodingKey {
        case itemId = "component_item_id", name, type, quantity, iconName="icon_name", iconColor="icon_color"
    }
}

extension Database {

    func armorComponents(armorId: Int) -> [ArmorComponent] {
        let query = Query(table: "components")
            .join(table: "items", on: "component_item_id")
            .filter("created_item_id", equals: armorId)
        return fetch(query)
    }
}
