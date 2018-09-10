//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation
import GRDB

class Location: RowConvertible {
    var id: Int
    var name: String
    var icon: String?
    
    lazy var monsters: [LocationMonster] = {
        return Database.shared.locationMonsters(locationId: self.id)
    }()
    
    func items(rank: Quest.Rank) -> [LocationItem] {
        return Database.shared.locationItems(locationId: self.id, rank: rank)
    }
    
    func itemsByNode(rank: Quest.Rank) -> [String: [LocationItem]] {
        let allItems = Database.shared.locationItems(locationId: self.id, rank: rank)
        var itemsByNode = [String: [LocationItem]]()
        for item in allItems {
            let nodeName = item.nodeName
            var node = itemsByNode[nodeName] ?? [LocationItem]()
            node.append(item)
            itemsByNode[nodeName] = node
        }
        return itemsByNode
    }
    
    required init(row: Row) {
        id = row["_id"]
        name = row["name"]
        icon = row["map"]
    }
}

class LocationMonster : RowConvertible {
    let monsterId: Int
    let monster: String?
    let icon: String?
    let startArea: String?
    let moneArea: String?
    let restArea: String?
    
    var areas: String {
        return "\(startArea ?? "")"
            + " > " + (moneArea ?? "")
            + " > \(restArea ?? "")"
    }
    
    required init(row: Row) {
        monsterId = row["monsterid"]
        monster = row["monstername"]
        icon = row["monstericon"]
        startArea = row["start_area"]
        moneArea = row["move_area"]
        restArea = row["rest_area"]
    }
}

class LocationItem : RowConvertible {
    var itemId: Int
    var name: String?
    var icon: String?
    var rank: String?
    var area: String?
    var site: String?
    var group: Int?
    var isFixed: Bool
    var isRare: Bool
    var chance: Int?
    var stack: Int?
    
    var nodeName: String {
        return "\(area ?? "")"
            + (isFixed ? " Fixed" : " Random")
            + (site != nil ? " \(site!)" : "")
            + (group != nil ? " \(group!)" : "")
            + (isRare ? " Rare" : "")
    }
    
    required init(row: Row) {
        itemId = row["itemid"]
        name = row["itemname"]
        icon = row["itemicon"]
        rank = row["rank"]
        area = row["area"]
        site = row["site"]
        group = row["group_num"]
        chance = row["percentage"]
        stack = row["quantity"]
        isFixed = (row["fixed"] ?? false)
        isRare = (row["rare"] ?? false)
    }
}

extension Database {
    
    func location(id: Int) -> Location {
        let query = "SELECT * FROM locations WHERE _id == '\(id)'"
        return fetch(query)[0]
    }
    
    func locations(_ search: String? = nil) -> [Location] {
        let query = "SELECT * FROM locations "
        let order = "ORDER BY name"
        return fetch(select: query, order: order, search: search)
    }
    
    func locationMonsters(locationId: Int) -> [LocationMonster] {
        let query = "SELECT *,"
            + " monsters.name AS monstername,"
            + " monsters.icon_name AS monstericon,"
            + " monsters._id AS monsterid"
            + " FROM monster_habitat"
            + " LEFT JOIN locations on monster_habitat.location_id = locations._id"
            + " LEFT JOIN monsters on monster_habitat.monster_id = monsters._id"
            + " WHERE locations._id == \(locationId)"
        return fetch(query)
    }
    
    func locationItems(locationId: Int, rank: Quest.Rank) -> [LocationItem] {
        let query = "SELECT *"
            + " ,items.name AS itemname,"
            + " items.icon_name AS itemicon,"
            + " items._id AS itemid"
            + " FROM gathering"
            + " LEFT JOIN items on gathering.item_id = items._id"
            + " LEFT JOIN locations on gathering.location_id = locations._id"
            + " WHERE locations._id == \(locationId)"
            + " AND rank == '\(rank.rawValue)'"
            + " ORDER BY site, percentage DESC"
        return fetch(query)
    }
}
