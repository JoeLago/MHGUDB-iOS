//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation
import GRDB

class SkillTree: RowConvertible {
    var id: Int
    var name: String
    
    lazy var skills: [Skill] = {
        return Database.shared.skills(skillTreeId: self.id)
    }()
    
    lazy var decorations: [SkillItem] = {
        return Database.shared.skillDecorations(skillTreeId: self.id)
    }()
    
    lazy var weapons: [SkillItem] = {
        return Database.shared.skillWeapons(skillTreeId: self.id)
    }()
    
    func armor(slot: Armor.Slot) -> [SkillItem] {
        return Database.shared.skillArmor(skillTreeId: self.id, slot: slot)
    }
    
    required init(row: Row) {
        id = row["_id"]
        name = row["name"]
    }
}

class Skill: RowConvertible {
    let name: String
    let description: String
    let points: Int
    
    required init(row: Row) {
        name = row["name"]
        description = row["description"]
        points = row["required_skill_tree_points"]
    }
}


class SkillItem: RowConvertible {
    let itemId: Int
    let name: String
    let icon: String
    let points: Int
    
    required init(row: Row) {
        itemId = row["itemid"]
        name = row["itemname"]
        icon = row["itemicon"]
        points = row["point_value"]
    }
}

extension Database {
    
    func skillTree(id: Int) -> SkillTree {
        let query = "SELECT * FROM skill_trees WHERE _id == '\(id)'"
        return fetch(query)[0]
    }
    
    func skillTrees() -> [SkillTree] {
        let query = "SELECT * FROM skill_trees ORDER BY name ASC"
        return fetch(query)
    }
    
    func skillTrees(_ search: String?) -> [SkillTree] {
        let query = "SELECT * FROM skill_trees"
        let order = "ORDER BY name ASC"
        return fetch(select: query, order: order, search: search)
    }
    
    func skills(skillTreeId: Int) -> [Skill] {
        let query = "SELECT * FROM skills WHERE skill_tree_id == \(skillTreeId)"
        return fetch(query)
    }
    
    func skillItemQuery(table: String, itemId: Int, slot: Armor.Slot? = nil) -> String {
        var query = "SELECT *,"
            + " items._id AS itemid,"
            + " items.name AS itemname,"
            + " items.icon_name AS itemicon"
            + " FROM \(table)"
            + " LEFT JOIN item_to_skill_tree ON \(table)._id = item_to_skill_tree.item_id"
            + " LEFT JOIN items ON item_to_skill_tree.item_id = items._id"
            + " LEFT JOIN skill_trees ON item_to_skill_tree.skill_tree_id = skill_trees._id"
            + " WHERE skill_trees._id == \(itemId)"
        
        if let slot = slot {
            query += " AND armor.slot = '\(slot.rawValue)'"
        }
        
        query += " ORDER BY item_to_skill_tree.point_value DESC"
        return query
    }
    
    // Don't exist in MHGDB?
    func skillWeapons(skillTreeId: Int) -> [SkillItem] {
        let query = skillItemQuery(table: "weapons", itemId: skillTreeId)
        return fetch(query)
    }
    
    func skillDecorations(skillTreeId: Int) -> [SkillItem] {
        let query = skillItemQuery(table: "decorations", itemId: skillTreeId)
        return fetch(query)
    }
    
    func skillArmor(skillTreeId: Int, slot: Armor.Slot) -> [SkillItem] {
        let query = skillItemQuery(table: "armor", itemId: skillTreeId, slot: slot)
        return fetch(query)
    }
}
