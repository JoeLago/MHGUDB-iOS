//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation
import GRDB

class Combination: RowConvertible {
    var id: Int!
    var createdId: Int!
    var createdName: String!
    var createdIcon: String?
    var firstId: Int!
    var firstName: String!
    var firstIcon: String?
    var secondId: Int!
    var secondName: String!
    var secondIcon: String?
    
    lazy var created: Item = {
        return Database.shared.item(id: self.createdId)
    }()
    
    lazy var first: Item = {
        return Database.shared.item(id: self.firstId)
    }()
    
    lazy var second: Item = {
        return Database.shared.item(id: self.secondId)
    }()
    
    required init(row: Row) {
        id = row["combineid"]
        createdId = row["createid"]
        createdName = row["createname"]
        createdIcon = row["createicon"]
        firstId = row["item1id"]
        firstName = row["item1name"]
        firstIcon = row["item1icon"]
        secondId = row["item2id"]
        secondName = row["item2name"]
        secondIcon = row["item2icon"]
    }
}

extension Database {
    
    var combinationQuery : String {
        return "SELECT"
        + " combining._id AS combineid,"
        + " createitem._id AS createid,"
        + " item1._id AS item1id,"
        + " item2._id AS item2id,"
        + " createitem.name AS createname,"
        + " item1.name AS item1name,"
        + " item2.name AS item2name,"
        + " createitem.icon_name AS createicon,"
        + " item1.icon_name AS item1icon,"
        + " item2.icon_name AS item2icon"
        + " FROM combining"
        + " LEFT JOIN items AS createitem ON combining.created_item_id = createitem._id"
        + " LEFT JOIN items AS item1 ON combining.item_1_id = item1._id"
        + " LEFT JOIN items AS item2 ON combining.item_2_id = item2._id"
    }
    
    func combination(id: Int) -> Combination {
        return fetch(combinationQuery + " WHERE combining._id = \(id)")[0]
    }
    
    func combinations(itemId: Int) -> [Combination] {
        return fetch(combinationQuery
            + " WHERE created_item_id == \(itemId)"
            + " OR item_1_id == \(itemId)"
            + " OR item_2_id == \(itemId)")
    }
    
    func combinations() -> [Combination] {
        return fetch(combinationQuery)
    }
}
