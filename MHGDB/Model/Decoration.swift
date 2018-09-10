//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation
import GRDB

class Decoration: RowConvertible {
    var id: Int
    var name: String
    var icon: String?
    var slots: Int
    let buy: Int
    let sell: Int
    
    lazy var skillTrees: [DecorationSkillTree] = {
        return Database.shared.decorationSkillTree(decorationId: self.id)
    }()
    
    lazy var components: [DecorationComponent] = {
        return Database.shared.decorationComponent(decorationId: self.id)
    }()
    
    var slotsString: String {
        return String(repeating: "O", count: slots) + String(repeating: "-", count: 3 - slots)
    }
    
    required init(row: Row) {
        id = row["_id"]
        name = row["name"]
        icon = row["icon_name"]
        slots = row["num_slots"]
        buy = row["buy"]
        sell = row["sell"]
    }
}

class DecorationSkillTree: RowConvertible {
    var skillId: Int
    var name: String
    var points: Int
    
    required init(row: Row) {
        skillId = row["skillid"]
        name = row["skillname"]
        points = row["point_value"]
    }
}

class DecorationComponent: RowConvertible {
    var componentId: Int
    var name: String
    var icon: String
    var type: String
    var quantity: Int
    
    required init(row: Row) {
        componentId = row["componentid"]
        name = row["componentname"]
        icon = row["componenticon"]
        type = row["componenttype"]
        quantity = row["quantity"]
    }
}

extension Database {
    
    func decoration(id: Int) -> Decoration {
        let query = "SELECT * FROM decorations LEFT JOIN items on decorations._id = items._id WHERE decorations._id = \(id)"
        return fetch(query)[0]
    }
    
    func decorations() -> [Decoration] {
        let query = "SELECT * FROM decorations LEFT JOIN items on decorations._id = items._id"
        return fetch(query)
    }
    
    func decorationSkillTree(decorationId: Int) -> [DecorationSkillTree] {
        let query = "SELECT *,"
            + " skill_trees.name AS skillname,"
            + " skill_trees._id AS skillid"
            + " FROM item_to_skill_tree"
            + " LEFT JOIN items ON item_to_skill_tree.item_id = items._id"
            + " LEFT JOIN skill_trees ON item_to_skill_tree.skill_tree_id = skill_trees._id"
            + " WHERE items._id == \(decorationId)"
        return fetch(query)
    }
    
    func decorationComponent(decorationId: Int) -> [DecorationComponent] {
        let query = "SELECT *,"
            + " component.name AS componentname,"
            + " component.icon_name AS componenticon,"
            + " components.type AS componenttype,"
            + " component._id AS componentid"
            + " FROM components"
            + " LEFT JOIN items ON components.created_item_id = items._id"
            + " LEFT JOIN items AS component ON components.component_item_id = component._id"
            + " WHERE items._id == \(decorationId)"
        return fetch(query)
    }
}
