//
// MIT License
// Copyright (c) Gathering Hall Studios
//

import GRDB

class Armor: FetchableRecord, Decodable {

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

    enum Slot: String, Decodable, CaseIterable {
        case head = "Head"
        case body = "Body"
        case arms = "Arms"
        case waist = "Waist"
        case legs = "Legs"

        var icon: String {
            switch self {
            case .head: return "icon_armor_head.png"
            case .body: return "icon_armor_body.png"
            case .arms: return "icon_armor_arms.png"
            case .waist: return "icon_armor_waist.png"
            case .legs: return "icon_armor_legs.png"
            }
        }
    }

    let id: Int
    let name: String
    var icon: Icon? {
        return Icon(name: slot?.icon ?? "", rarity: rarity)
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

    var fire = 0
    var water = 0
    var thunder = 0
    var ice = 0
    var dragon = 0

    var slotsString: String {
        return String(repeating: "O", count: slots) + String(repeating: "-", count: 3 - slots)
    }

    lazy var skills: [ArmorSkill] = {
        return Database.shared.armorSkills(armorId: self.id)
    }()

    lazy var components: [ArmorComponent] = {
        return Database.shared.armorComponents(armorId: id)
    }()

    var resistances: Resistances {
        return Resistances(fire: fire, water: water, thunder: thunder, ice: ice, dragon: dragon)
    }

    enum CodingKeys: String, CodingKey {
        case id="_id", name, defense, defenseMax="max_defense", buy="buy", sell, slots="num_slots", rarity, slot, fire="fire_res", water="water_res", thunder="thunder_res", ice="ice_res", dragon="dragon_res"

    }
}

extension Database {

    func armor(id: Int) -> Armor {
        let query = Query(table: "armor")
            .join(table: "items")
            .filter(id: id)
        return fetch(query)[0]
    }

    func armor(_ search: String? = nil, hunterType: Armor.HunterType? = nil, slot: Armor.Slot? = nil) -> [Armor] {
        let query = Query(table: "armor")
            .join(table: "items")

        if let hunterType = hunterType, hunterType != .all {
            query.filter("hunter_type", equals: hunterType.rawValue)
        }

        if let slot = slot {
            query.filter("slot", equals: slot.rawValue)
        }

        return fetch(query)
    }
}
