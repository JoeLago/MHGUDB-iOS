//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation
import GRDB
import UIKit

class Item: RowConvertible {
    let id: Int
    var name: String
    var description: String?
    var icon: Icon?
    let stack: Int
    let buy: Int
    let sell: Int
    
    lazy var quests: [ItemQuest] = {
        return Database.shared.rewards(itemId: self.id)
    }()
    
    lazy var combinations: [Combination] = {
        return Database.shared.combinations(itemId: self.id)
    }()
    
    lazy var locations: [ItemLocation] = {
        return Database.shared.locations(itemId: self.id)
    }()
    
    lazy var monsters: [ItemMonster] = {
        return Database.shared.monsters(itemId: self.id)
    }()
    
    lazy var armor: [ItemComponent] = {
        return Database.shared.armor(itemId: self.id)
    }()
    
    lazy var weapons: [ItemComponent] = {
        return Database.shared.weapons(itemId: self.id)
    }()
    
    lazy var decorations: [ItemComponent] = {
        return Database.shared.decorations(itemId: self.id)
    }()
    
    required init(row: Row) {
        id = row["_id"]
        name = row["name"]
        description = row["description"]
        icon = Icon(row: row)
        stack = row["carry_capacity"]
        buy = row["buy"]
        sell = row["sell"]
    }
}

class ItemQuest: RowConvertible {
    let questId: Int
    let name: String
    let icon: String?
    let quantity: Int
    let chance: Int
    let slot: String
    let stars: Int
    let hub: String
    
    required init(row: Row) {
        questId = row["questid"]
        icon = nil
        name = row["questname"]
        quantity = row["stack_size"]
        chance = row["percentage"]
        slot = row["reward_slot"]
        stars = row["stars"]
        hub = row["hub"]
    }
}

class ItemLocation: RowConvertible {
    var id: Int
    var name: String
    var icon: String
    var rank: String // TODO: use enum
    var area: String
    var site: String
    var stack: Int
    var chance: Int
    var isFixed: Bool
    var isRare: Bool
    var group: Int
    
    var nodeName: String {
        return "\(area) \(isFixed ? "Fixed" : "Random") \(site) \(group) \(isRare ? " Rare" : "")"
    }
    
    required init(row: Row) {
        id = row["location_id"]
        name = row["locationname"]
        icon = row["map"]
        rank = row["rank"]
        area = row["area"]
        site = row["site"]
        chance = row["percentage"]
        stack = row["quantity"]
        group = row["group_num"]
        isFixed = (row["fixed"] ?? false)
        isRare = (row["rare"] ?? false)
    }
}

class ItemMonster: RowConvertible {
    let id: Int
    let monsterId: Int
    let name: String
    let icon: String
    let condition: String
    let rank: Quest.Rank
    let stack: Int
    let chance: Int
    
    required init(row: Row) {
        id = row["_id"]
        monsterId = row["monsterid"]
        name = row["monstername"]
        icon = row["monstericon"]
        condition = row["condition"]
        rank = (row["rank"] as String == "LR") ? .low : .high
        stack = row["stack_size"]
        chance = row["percentage"]
    }
}

class ItemComponent: RowConvertible {
    var id: Int
    var producedId: Int
    var name: String
    var icon: String
    var quantity: Int
    
    required init(row: Row) {
        id = row["itemid"]
        producedId = row["itemid"]
        name = row["createdname"]
        icon = row["createdicon"]
        quantity = row["quantity"]
    }
}

extension Database {
    func items(_ search: String? = nil) -> [Item] {
        let query = "SELECT * FROM items"
        let order = "ORDER BY _id ASC"
        return fetch(select: query, order: order, filter: "sub_type == '' AND type == ''", search: search)
    }
    
    func item(id: Int) -> Item {
        let query = "SELECT * FROM items WHERE _id == '\(id)'"
        return fetch(query)[0]
    }
    
    func rewards(itemId: Int) -> [ItemQuest] {
        let query = rewardsQuery
            + " WHERE items._id == \(itemId)"
            + " ORDER BY hub, stars, percentage DESC"
        return fetch(query)
    }
    
    func locations(itemId: Int) -> [ItemLocation] {
        let query = "SELECT *,"
            + " locations.name AS locationname"
            + " FROM gathering"
            + " LEFT JOIN items on gathering.item_id = items._id"
            + " LEFT JOIN locations on gathering.location_id = locations._id"
            + " WHERE items._id == \(itemId)"
        return fetch(query)
    }
    
    func monsters(itemId: Int) -> [ItemMonster] {
        let query = "SELECT *,"
            + " monsters.name AS monstername,"
            + " monsters.icon_name AS monstericon,"
            + " monsters._id AS monsterid"
            + " FROM hunting_rewards"
            + " LEFT JOIN items on hunting_rewards.item_id = items._id"
            + " LEFT JOIN monsters on hunting_rewards.monster_id = monsters._id"
            + " WHERE items._id == \(itemId)"
        return fetch(query)
    }
    
    func armor(itemId: Int) -> [ItemComponent] {
        let query = "SELECT *,"
            + " created.name AS createdname,"
            + " created.icon_name AS createdicon,"
            + " created._id as itemid"
            + " FROM armor"
            + " LEFT JOIN components ON armor._id = components.created_item_id"
            + " LEFT JOIN items AS created on components.created_item_id = created._id"
            + " LEFT JOIN items ON components.component_item_id = items._id"
            + " WHERE items._id == \(itemId)"
        return fetch(query)
    }
    
    func weapons(itemId: Int) -> [ItemComponent] {
        let query = "SELECT *,"
            + " created.name AS createdname,"
            + " created.icon_name AS createdicon,"
            + " created._id as itemid"
            + " FROM weapons"
            + " LEFT JOIN components ON weapons._id = components.created_item_id"
            + " LEFT JOIN items AS created on components.created_item_id = created._id"
            + " LEFT JOIN items ON components.component_item_id = items._id"
            + " WHERE items._id == \(itemId)"
        return fetch(query)
    }
    
    func decorations(itemId: Int) -> [ItemComponent] {
        let query = "SELECT *,"
            + " created.name AS createdname,"
            + " created.icon_name AS createdicon,"
            + " created._id as itemid"
            + " FROM decorations"
            + " LEFT JOIN components ON decorations._id = components.created_item_id"
            + " LEFT JOIN items AS created on components.created_item_id = created._id"
            + " LEFT JOIN items ON components.component_item_id = items._id"
            + " WHERE items._id == \(itemId)"
        return fetch(query)
    }
}
