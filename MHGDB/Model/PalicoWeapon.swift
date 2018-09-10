//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation
import GRDB

class PalicoWeapon: RowConvertible {
    enum Balance: Int {
        case balanced = 0, meleePlus, rangedPlus
        
        var string: String {
            switch self {
            case .balanced: return "Balanced"
            case .meleePlus: return "Melee+"
            case .rangedPlus: return "Ranged+"
            }
        }
    }
    
    var id: Int
    var name: String
    var icon: String?
    var description: String
    var attackMelee: Int
    var attackRanged: Int
    
    var balanceValue: Int
    var balance: Balance {
        return Balance(rawValue: balanceValue) ?? .balanced
    }
    
    var elementString: String?
    var element: Element? {
        if let elementString = elementString {
            return Element(rawValue: elementString)
        } else {
            return nil
        }
    }
    
    var elementMelee: Int?
    var elementRanged: Int?
    var defense: Int?
    var sharpnessValue: Int
    var sharpness: Sharpness {
        return Sharpness(palicoSharpness: sharpnessValue)
    }
    var affinityMelee: Int
    var affinityRanged: Int
    var isBlunt: Bool
    var type: String {
        return isBlunt ? "Blunt" : "Cutting"
    }
    var creationCost: Int
    
    
    lazy var components: [Component] = {
        return Database.shared.components(itemId: self.id)
    }()
    
    required init(row: Row) {
        id = row["_id"]
        name = row["name"]
        icon = row["icon_name"]
        description = row["description"]
        attackMelee = row["attack_melee"]
        attackRanged = row["attack_ranged"]
        balanceValue = row["balance"]
        elementString = row["element"]
        elementMelee = row["element_melee"]
        elementRanged = row["element_ranged"]
        defense = row["defense"]
        sharpnessValue = row["sharpness"]
        affinityMelee = row["affinity_melee"]
        affinityRanged = row["affinity_ranged"]
        isBlunt = row["blunt"]
        creationCost = row["creation_cost"]
    }
}


extension Database {
    
    func palicoWeapon(id: Int) -> PalicoWeapon {
        let query = "SELECT * FROM palico_weapons LEFT JOIN items on palico_weapons._id = items._id"
            + " WHERE palico_weapons._id = \(id)"
        return fetch(query)[0]
    }
    
    func palicoWeapons() -> [PalicoWeapon] {
        let query = "SELECT * FROM palico_weapons LEFT JOIN items on palico_weapons._id = items._id"
        return fetch(query)
    }
    
    func palicoWeapons(_ search: String) -> [PalicoWeapon] {
        let query = "SELECT * FROM palico_weapons LEFT JOIN items on palico_weapons._id = items._id"
        return fetch(select: query, search: search)
    }
}
