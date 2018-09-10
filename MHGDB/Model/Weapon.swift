//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation
import GRDB

class Weapon: RowConvertible {
    
    enum WType: String {
        case greatSword = "Great Sword"
        case longSword = "Long Sword"
        case swordAndShield = "Sword and Shield"
        case dualBlades = "Dual Blades"
        case hammer = "Hammer"
        case huntingHorm = "Hunting Horn"
        case lance = "Lance"
        case gunlance = "Gunlance"
        case switchAxe = "Switch Axe"
        case chargeBlade = "Charge Blade"
        case insectGlaive = "Insect Glaive"
        case lightBowgun = "Light Bowgun"
        case heavyBowgun = "Heavy Bowgun"
        case bow = "Bow"
        case unknown = "Unknown"
        
        static var allValues: [WType] {
            return [.greatSword, .longSword, .swordAndShield, .dualBlades, .hammer, .huntingHorm,
                    .lance, .gunlance, .switchAxe, .chargeBlade, .insectGlaive, .lightBowgun, .heavyBowgun,
                    .bow]
        }
        
        var imagePrefix: String {
            switch self {
            case .greatSword: return "great_sword"
            case .longSword: return "long_sword"
            case .swordAndShield: return "sword_and_shield"
            case .dualBlades: return "dual_blades"
            case .hammer: return "hammer"
            case .huntingHorm: return "hunting_horn"
            case .lance: return "lance"
            case .gunlance: return "gunlance"
            case .switchAxe: return "switch_axe"
            case .chargeBlade: return "charge_blade"
            case .insectGlaive: return "insect_glaive"
            case .lightBowgun: return "light_bowgun"
            case .heavyBowgun: return "heavy_bowgun"
            case .bow: return "bow"
            case .unknown: return ""
            }
        }
        
        var imageName: String {
            switch self {
            case .greatSword: return "great_sword8.png"
            case .longSword: return "long_sword2.png"
            case .swordAndShield: return "sword_and_shield3.png"
            case .dualBlades: return "dual_blades4.png"
            case .hammer: return "hammer5.png"
            case .huntingHorm: return "hunting_horn6.png"
            case .lance: return "lance7.png"
            case .gunlance: return "gunlance8.png"
            case .switchAxe: return "switch_axe9.png"
            case .chargeBlade: return "charge_blade10.png"
            case .insectGlaive: return "insect_glaive2.png"
            case .lightBowgun: return "light_bowgun3.png"
            case .heavyBowgun: return "heavy_bowgun4.png"
            case .bow: return "bow5.png"
            case .unknown: return ""
            }
        }
    }
    
    var id: Int
    var parentId: Int?
    var name: String
    var icon: String? {
        return "\(type.imagePrefix)\(rarity).png"
    }
    var type: WType
    var depths: [Bool]?
    var children = [Weapon]()
    var attack: Int?
    var element: Element?
    var elementAttack: Int?
    var awakenElement: Element?
    var awakenAttack: Int?
    var defense: Int?
    var sharpnesses: [Sharpness]?
    var numSlots: Int?
    var creationCost: Int?
    var upgradeCost: Int?
    var sell: Int?
    var affinity: Int?
    var rarity: Int
    
    // specific to weapon type
    var recoil: String?
    var reloadSpeed: String?
    var rapidFire: String?
    var deviation: String?
    var ammoString: String?
    var ammo: Ammo?
    var specialAmmo: String?
    var coatings: String?
    var charges: String?
    var phial: String?
    var phialAttack: Int?
    var shellingType: String?
    var notes: String?
    
    var components: [Component] {
        return Database.shared.components(itemId: id)
    }
    
    struct Note {
        let imageName: String
    }
    
    required init(row: Row) {
        id = row["_id"]
        parentId = row["parent_id"]
        name = row["name"]
        attack = row["attack"]
        defense = row["def"]
        numSlots = row["num_slots"]
        rarity = row["rarity"]
        creationCost = row["creation_cost"]
        upgradeCost = row["upgrade_cost"]
        sell = row["sell"]
        elementAttack = row["element_attack"]
        recoil = row["recoil"]
        reloadSpeed = row["reload_speed"]
        rapidFire = row["rapid_fire"]
        deviation = row["deviation"]
        ammoString = row["ammo"]
        
        type = WType(rawValue: row["wtype"]) ?? .unknown
        
        if let ammoString = ammoString {
            ammo = Ammo(string: ammoString)
        }
        
        specialAmmo = row["special_ammo"]
        coatings = row["coatings"]
        charges = row["charges"]
        phial = row["phial"]
        shellingType = row["shelling_type"]
        notes = row["horn_notes"]
        
        if elementAttack ?? 0 > 0, let elementString: String = row["element"] {
            element = Element(rawValue: elementString)
        }
        
        if type == .switchAxe, element == nil, elementAttack ?? 0 > 0 {
            phialAttack = elementAttack
            elementAttack = nil
        }
        
        let sharpnessesString: String? = row["sharpness"]
        if let sharpnessesString = sharpnessesString {
            let sharpnessStrings = sharpnessesString.components(separatedBy: " ")
            if sharpnessStrings.count >= 3 {
                sharpnesses = [Sharpness(string: sharpnessStrings[0]),
                               Sharpness(string: sharpnessStrings[1]),
                               Sharpness(string: sharpnessStrings[2])]
            }
        }
    }

    var noteImageNames: [String]? {
        if let notes = notes {
          return notes.compactMap({ (c: Character) -> String? in
                switch c {
                case "A": return "Note.aqua.png"
                case "B": return "Note.blue.png"
                case "G": return "Note.green.png"
                case "O": return "Note.orange.png"
                case "P": return "Note.purple.png"
                case "R": return "Note.red.png"
                case "W": return "Note.white.png"
                case "Y": return "Note.yellow.png"
                default: return nil
                }
            })
        } else {
            return nil
        }
    }
    
    var coatingImageNames: [String]? {
        /* TODO:
         (TextView)view.findViewById(R.id.power_1_text),
         (TextView)view.findViewById(R.id.power_2_text),
         (TextView)view.findViewById(R.id.element_1_text),
         (TextView)view.findViewById(R.id.element_2_text),
         (TextView)view.findViewById(R.id.crange_text),
         (TextView)view.findViewById(R.id.poison_text),
         (TextView)view.findViewById(R.id.para_text),
         (TextView)view.findViewById(R.id.sleep_text),
         (TextView)view.findViewById(R.id.exhaust_text),
         (TextView)view.findViewById(R.id.blast_text),
         (TextView)view.findViewById(R.id.paint_text)
         
         missing yellowgreen, slime, pink, green, empty
         */
        if let coatings = Int(coatings) {
            var coatingImageNames = [String]()
            
            if (coatings & 0x0400) > 0 || (coatings & 0x0200) > 0 { coatingImageNames.append("Bottle-Red.png") }
            if (coatings & 0x20) > 0 { coatingImageNames.append("Bottle-Purple.png") }
            if (coatings & 0x10) > 0 { coatingImageNames.append("Bottle-Yellow.png") }
            if (coatings & 0x08) > 0 { coatingImageNames.append("Bottle-Cyan.png") }
            if (coatings & 0x40) > 0 { coatingImageNames.append("Bottle-White.png") }
            if (coatings & 0x04) > 0 { coatingImageNames.append("Bottle-Blue.png") }
            if (coatings & 0x02) > 0 { coatingImageNames.append("Bottle-Orange.png") }
            
            return coatingImageNames
        } else {
            return nil
        }
    }
    
    var numChildren: Int {
        get {
            var count = 0
            for weapon in children {
                count += 1
                count += weapon.numChildren
            }
            
            return count
        }
    }
    
    func allChildren() -> [Weapon] {
        var allChildren = [Weapon]()
        for child in children {
            allChildren.append(child)
            allChildren += child.allChildren()
        }
        
        return allChildren
    }
}

extension Weapon: CustomDebugStringConvertible {
    var debugDescription: String {
        return name
    }
}

extension Weapon: CustomStringConvertible {
    var description: String {
        return name
    }
}

class AmmoType: StyledText {
    // TODO: text should be int value and isbold should be named whatever that represents
    // text and isBold should be in separate extension 
    // (in AmmoCell.swift since it's a UI thing) 
    // and return these new values to conform to protocol
    
    let text: String
    let isBold: Bool
    
    init(text: String, isBold: Bool = false) {
        self.text = text
        self.isBold = isBold
    }
    
    convenience init(_ values: [String], _ index: Int) {
        let stringValue = values[index]
        if let index = stringValue.range(of: "*") {
            self.init(text: String(stringValue[..<index.lowerBound]), isBold: true)
        }
        else {
            self.init(text: stringValue)
        }
    }
}

class Ammo {
    let normal1: AmmoType
    let normal2: AmmoType
    let normal3: AmmoType
    let pierce1: AmmoType
    let pierce2: AmmoType
    let pierce3: AmmoType
    let pellet1: AmmoType
    let pellet2: AmmoType
    let pellet3: AmmoType
    let crag1: AmmoType
    let crag2: AmmoType
    let crag3: AmmoType
    let clust1: AmmoType
    let clust2: AmmoType
    let clust3: AmmoType
    let poison1: AmmoType
    let poison2: AmmoType
    let paralysis1: AmmoType
    let paralysis2: AmmoType
    let sleep1: AmmoType
    let sleep2: AmmoType
    let exhaust1: AmmoType
    let exhaust2: AmmoType
    let fire: AmmoType
    let water: AmmoType
    let thunder: AmmoType
    let ice: AmmoType
    let dragon: AmmoType
    
    init(string: String) {
        let values = string.components(separatedBy: "|")
        
        normal1 = AmmoType(values, 0)
        normal2 = AmmoType(values, 1)
        normal3 = AmmoType(values, 2)
        pierce1 = AmmoType(values, 3)
        pierce2 = AmmoType(values, 4)
        pierce3 = AmmoType(values, 5)
        pellet1 = AmmoType(values, 6)
        pellet2 = AmmoType(values, 7)
        pellet3 = AmmoType(values, 8)
        crag1 = AmmoType(values, 9)
        crag2 = AmmoType(values, 10)
        crag3 = AmmoType(values, 11)
        clust1 = AmmoType(values, 12)
        clust2 = AmmoType(values, 13)
        clust3 = AmmoType(values, 14)
        
        fire = AmmoType(values, 15)
        water = AmmoType(values, 16)
        thunder = AmmoType(values, 17)
        ice = AmmoType(values, 18)
        dragon = AmmoType(values, 19)
        
        poison1 = AmmoType(values, 20)
        poison2 = AmmoType(values, 21)
        paralysis1 = AmmoType(values, 22)
        paralysis2 = AmmoType(values, 23)
        sleep1 = AmmoType(values, 24)
        sleep2 = AmmoType(values, 25)
        exhaust1 = AmmoType(values, 26)
        exhaust2 = AmmoType(values, 27)
    }
}

extension Database {
    
    func weapon(id: Int) -> Weapon {
        let query = "SELECT * FROM weapons LEFT JOIN items on weapons._id = items._id WHERE weapons._id = \(id)"
        return fetch(query)[0]
    }
    
    func allWeapons() -> [Weapon] {
        let query = "SELECT * FROM weapons LEFT JOIN items on weapons._id = items._id"
        return fetch(query)
    }
    
    func weapons(_ search: String) -> [Weapon] {
        let query = "SELECT * FROM weapons LEFT JOIN items on weapons._id = items._id"
        let filter =  "weapons.wtype IS NOT NULL"
        return fetch(select: query, filter: filter, search: search)
    }
    
    func weaponQuery(type: Weapon.WType) -> String {
        return "SELECT *"
            + " FROM weapons"
            + " LEFT JOIN items on weapons._id = items._id"
            + " WHERE wtype == '" + type.rawValue + "'"
    }
    
    func weaponsByParent(type: Weapon.WType) -> [Int: [Weapon]] {
        var weaponsByParent = [Int: [Weapon]]()
        
        let query = weaponQuery(type: type)
        let weapons = fetch(query) as [Weapon]
        for weapon in weapons {
            var children = weaponsByParent[weapon.parentId!] ?? [Weapon]()
            children.append(weapon)
            weaponsByParent[weapon.parentId!] = children
        }
        
        return weaponsByParent
    }
    
    func weaponTree(type: Weapon.WType) -> Tree<Weapon>? {
        let weaponParentTable = weaponsByParent(type: type)
        let tree = Tree<Weapon>(objects: weaponParentTable[0]!)
        for node in tree.roots {
            populateNode(node: node, weaponsByParent: weaponParentTable)
        }
        return tree
    }
    
    func populateNode(node: Node<Weapon>, weaponsByParent: [Int: [Weapon]]) {
        guard let weapons = weaponsByParent[node.object.id] else {
            return
        }
        node.addChildren(weapons)
        
        for node in node.children {
            populateNode(node: node, weaponsByParent: weaponsByParent)
        }
    }
    
    func weaponTree(weaponId: Int) -> (Node<Weapon>, Tree<Weapon>) {
        let baseWeapon = weapon(id: weaponId)
        
        let weaponNode = Node(baseWeapon)
        var topNode = weaponNode
        while let parentId = topNode.object.parentId, parentId > 0 {
            let parentWeapon = weapon(id: parentId)
            let parent = Node(parentWeapon)
            parent.children.append(topNode)
            topNode.parent = parent
            topNode = parent
        }
        
        let weapons = weaponsByParent(type: baseWeapon.type)
        populateNode(node: weaponNode, weaponsByParent: weapons)
        
        let tree = Tree<Weapon>()
        tree.roots.append(topNode)
        return (weaponNode, tree)
    }
}
