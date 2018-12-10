//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation
import GRDB

class Combination: FetchableRecord, Decodable {
    var id: Int
    var minCreated: Int
    var maxCreated: Int
    var chancePercentage: Int
    var createdId: Int
    var firstId: Int
    var secondId: Int
    
    lazy var created: Item = { return Database.shared.item(id: self.createdId) }()
    lazy var first: Item = { return Database.shared.item(id: self.firstId) }()
    lazy var second: Item = { return Database.shared.item(id: self.secondId) }()

    enum CodingKeys: String, CodingKey {
        case id="_id", minCreated="amount_made_min", maxCreated="amount_made_max", chancePercentage="percentage", createdId="created_item_id", firstId="item_1_id", secondId="item_2_id"
    }
}

extension Database {
    var combinationQuery: Query {
        let query = Query(table: "combining")
        return query
    }

    func combination(id: Int) -> Combination {
        let query = combinationQuery.filter("created_item_id", equals: id)
        return fetch(query)[0]
    }

    func combinations(itemId: Int) -> [Combination] {
        let query = combinationQuery.orFilter([
            Query.Filter(attribute: "created_item_id", value: itemId),
            Query.Filter(attribute: "item_1_id", value: itemId),
            Query.Filter(attribute: "item_2_id", value: itemId)
            ])
        return fetch(query)
    }

    func combinations() -> [Combination] {
        return fetch(combinationQuery)
    }
}
