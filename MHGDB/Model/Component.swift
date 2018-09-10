//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation
import GRDB

class Component: RowConvertible {
    let id: Int
    let name: String
    let icon: String
    let type: String?
    let quantity: Int
    
    required init(row: Row) {
        id = row["cid"]
        name = row["cname"]
        icon = row["cicon_name"]
        type = row["ctype"]
        quantity = row["quantity"]
    }
}

extension Database {

    func components(itemId: Int) -> [Component] {
        let query = "SELECT *,"
            + " component.name AS cname,"
            + " component.icon_name AS cicon_name,"
            + " components.type AS ctype,"
            + " component._id AS cid"
            + " FROM components"
            + " LEFT JOIN items ON components.created_item_id = items._id"
            + " LEFT JOIN items AS component ON components.component_item_id = component._id"
            + " WHERE items._id == \(itemId)"
        return fetch(query)
    }
}
