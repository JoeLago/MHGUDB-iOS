//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation
import GRDB

class Armor: RowConvertible {
    
    enum HunterType: Int {
        case blade = 0, gunner, both, all
        
        var string: String {
            switch self {
            case .blade: return "Blade"
            case .gunner: return "Gunner"
            case .both: return "Both"
            case .all: return "All Types"
            }
        }
        
        static func forString(_ string: String) -> HunterType? {
            switch string {
            case blade.string: return .blade
            case gunner.string: return .gunner
            case both.string: return .both
            case all.string: return .all
            default: return nil
            }
        }
        
        static var allStringValues: [String] {
            return [all.string, blade.string, gunner.string, both.string]
        }
    }
    
    enum Slot: String {
        case head = "Head"
        case body = "Body"
        case arms = "Arms"
        case waist = "Waist"
        case legs = "Legs"
        
        static func forString(_ string: String) -> Slot? {
            switch string {
            case head.rawValue: return .head
            case body.rawValue: return .body
            case arms.rawValue: return .arms
            case waist.rawValue: return .waist
            case legs.rawValue: return .legs
            default: return nil
            }
        }
        
        static var allStringValues: [String] {
            return [head.rawValue, body.rawValue, arms.rawValue, waist.rawValue, legs.rawValue]
        }
    }
    
    let id: Int
    let name: String
    var icon: String {
        let imageName = "\(slot?.rawValue.lowercased() ?? "")\(rarity).png"
        return imageName
    }
    let defense: Int
    let defenseMax: Int
    let buy: Int
    let sell: Int
    let slots: Int
    let rarity: Int
    let slot: Slot?
    
    // gender?
    // hunter type?
    // family?
    // monster?
    
    var slotsString: String {
        return String(repeating: "O", count: slots) + String(repeating: "-", count: 3 - slots)
    }
    
    lazy var skills: [ArmorSkill] = {
        return Database.shared.armorSkills(itemId: self.id)
    }()
    
    lazy var components: [ArmorComponent] = {
        return Database.shared.armorComponents(armorId: self.id)
    }()
    
    var resistances: Resistances
    
    required init(row: Row) {
        id = row["_id"]
        name = row["name"]
        defense = row["defense"]
        defenseMax = row["max_defense"]
        buy = row["buy"]
        sell = row["sell"]
        slots = row["num_slots"]
        rarity = row["rarity"]
        slot = Slot.forString(row["slot"])
        resistances = Resistances(row: row)
    }
}

class ArmorSkill: RowConvertible {
    let skillId: Int
    var name: String
    var value: Int
    
    required init(row: Row) {
        skillId = row["skillid"]
        name = row["skillname"]
        value = row["point_value"]
    }
}

class ArmorComponent: RowConvertible {
    var itemId: Int
    var name: String
    var icon: String?
    var type: String?
    var quantity: Int?
    
    required init(row: Row) {
        itemId = row["componentid"]
        name = row["componentname"]
        icon = row["componenticon"]
        type = row["componenttype"]
        quantity = row["quantity"]
    }
}

extension Database {
    
    func armor(id: Int) -> Armor {
        let query = "SELECT * FROM armor LEFT JOIN items on armor._id = items._id WHERE armor._id = \(id)"
        return fetch(query)[0]
    }
    
    func armor(_ search: String? = nil, hunterType: Armor.HunterType? = nil, slot: Armor.Slot? = nil) -> [Armor] {
        let query = "SELECT * FROM armor LEFT JOIN items on armor._id = items._id"
        var filter = ""
        
        let finalHunterType = hunterType == .all ? nil : hunterType
        if let finalHunterType = finalHunterType {
            filter = "hunter_type == '\(finalHunterType.rawValue)'"
        }
        
        if let slot = slot {
            filter += (finalHunterType != nil ? " AND " : "") + "slot == '\(slot.rawValue)'"
        }
        
        return fetch(select: query, filter: filter, search: search)
    }
    
    func armorSkills(itemId: Int) -> [ArmorSkill] {
        let query = "SELECT *,"
            + " skill_trees.name AS skillname,"
            + " skill_trees._id AS skillid"
            + " FROM item_to_skill_tree"
            + " LEFT JOIN items ON item_to_skill_tree.item_id = items._id"
            + " LEFT JOIN skill_trees ON item_to_skill_tree.skill_tree_id = skill_trees._id"
            + " WHERE items._id == \(itemId)"
        return fetch(query)
    }
    
    func armorComponents(armorId: Int) -> [ArmorComponent] {
        let query = "SELECT"
            + " component._id AS componentid,"
            + " component.name AS componentname,"
            + " component.icon_name AS componenticon,"
            + " component.type AS componenttype"
            + " FROM components"
            + " LEFT JOIN items ON components.created_item_id = items._id"
            + " LEFT JOIN items AS component ON components.component_item_id = component._id"
            + " WHERE items._id == \(armorId)"
        return fetch(query)
    }
}
