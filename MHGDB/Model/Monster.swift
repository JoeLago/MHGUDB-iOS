//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation
import GRDB


class Monster: RowConvertible {
    enum Size: String {
        case large = "Large"
        case small = "Small"
        
        init?(_ size: Int?) {
            if size == nil {
                return nil
            }
            
            switch size! {
            case 0: self = .large
            case 1: self = .small
            default: return nil
            }
        }
    }
    
    var id: Int
    var name: String
    var icon: String?
    var size: Size?
    
    var weaknesses: [Weaknesses] {
        return Database.shared.weaknesses(forMonsterId: id)
    }
    
    var habitats: [MonsterHabitat] {
        return Database.shared.habitats(monsterId: id)
    }
    
    var quests: [MonsterQuest] {
        return Database.shared.quests(monsterId: id)
    }
    
    func rewards(rank: Quest.Rank) -> [MonsterReward] {
        return Database.shared.rewards(monsterId: id, rank: rank)
    }
    
    func rewardsByCondition(rank: Quest.Rank) -> [String: [MonsterReward]] {
        let allRewards = Database.shared.rewards(monsterId: id, rank: rank)
        var rewardsByCondition = [String: [MonsterReward]]()
        for reward in allRewards {
            var condition = rewardsByCondition[reward.condition] ?? [MonsterReward]()
            condition.append(reward)
            rewardsByCondition[reward.condition] = condition
        }
        return rewardsByCondition
    }
    
    var damage: [MonsterDamage] {
        return Database.shared.monsterDamage(monsterId: id)
    }
    
    var statuses: [MonsterStatusValues] {
        let stats = Database.shared.monsterStatus(monsterId: id)
        var rows = [String: Row]()
        for stat in stats {
            rows[stat.status] = stat.row
        }
        
        var statuses = [MonsterStatusValues]()
        
        /*status = row["status"]
        initial = row["initial"]
        increase = row["increase"]
        max = row["max"]
        duration = row["duration"]
        damage = row["damage"]*/
        
        statuses.append(MonsterStatusValues(values: rows, column: "initial"))
        statuses.append(MonsterStatusValues(values: rows, column: "increase"))
        statuses.append(MonsterStatusValues(values: rows, column: "max"))
        statuses.append(MonsterStatusValues(values: rows, column: "duration"))
        statuses.append(MonsterStatusValues(values: rows, column: "damage"))
        
        return statuses
    }
    
    // This function is poorly written
    var damageByPart: [MonsterDamageByPart] {
        var parts = [String: MonsterDamageByPart]()
        let dmgs = damage
        
        for dmg in dmgs {
            let state = dmg.bodyPart.slice(from: "(", to: ")") ?? "Normal"
            let existing = parts[state] ?? MonsterDamageByPart()
            if parts[state] == nil {
                parts[state] = existing
                existing.state = state
            }
            dmg.bodyPart = dmg.bodyPart.replacingOccurrences(of: " (\(state))", with: "")
            existing.damage.append(dmg)
        }
        
        // Reversed puts normal on top, should do a more safe algorithm
        return [MonsterDamageByPart](parts.values).reversed()
    }
    
    func ailments() -> [String]? {
        let ailments = Database.shared.monsterAilments(monsterId: id)
        return ailments.count > 0 ? ailments : nil
    }
    
    required init(row: Row) {
        id = row["_id"]
        name = row["name"]
        icon = row["icon_name"]
        size = Size(Int(row["class"] as String))
    }
}

class Weaknesses: Elements, RowConvertible {
    var paralysis = 0
    var sleep = 0
    var pitfallTrap = 0
    var shockTrap = 0
    var flashBomb = 0
    var sonicBomb = 0
    var dungBomb = 0
    var meat = 0
    
    required init(row: Row) {
        super.init()
        state = row["state"]
        fire = row["fire"]
        water = row["water"]
        thunder = row["thunder"]
        ice = row["ice"]
        dragon = row["dragon"]
        poison = row["poison"]
        paralysis = row["paralysis"]
        sleep = row["sleep"]
        pitfallTrap = row["pitfall_trap"]
        shockTrap = row["shock_trap"]
        flashBomb = row["flash_bomb"]
        sonicBomb = row["sonic_bomb"]
        dungBomb = row["dung_bomb"]
        meat = row["meat"]
    }
}

class MonsterQuest: RowConvertible {
    var questId: Int
    var questName: String?
    var questIcon: String?
    var goal: String?
    var hub: String
    var stars: Int
    var goalType: Quest.Goal?
    var progression: Quest.Progression?
    
    required init(row: Row) {
        questId = row["questid"]
        questName = row["questname"]
        stars = row["stars"]
        hub = row["hub"]
        questIcon = row["icon_name"]
        goal = row["goal"]
        goalType = Quest.Goal(row["goal_type"])
        progression = Quest.Progression(Int(row["type"] as String))
    }
}

class MonsterHabitat : RowConvertible {
    var locationId: Int
    var location: String?
    var startArea: String?
    var moveArea: String?
    var restArea: String?
    
    var string: String {
      return [startArea, moveArea, restArea].compactMap{ $0 }.joined(separator: " > ")
    }
    
    required init(row: Row) {
        locationId = row["locationid"]
        location = row["locationname"]
        startArea = row["start_area"]
        moveArea = row["move_area"]
        restArea = row["rest_area"]
    }
}

class MonsterReward: RowConvertible {
    enum Source {
        case carve, capture, kill
    }
    
    var itemId: Int
    var name: String
    var icon: String?
    var condition: String
    var rank: Quest.Rank?
    var stackSize: Int?
    var chance: Int?
    
    required init(row: Row) {
        itemId = row["itemid"]
        name = row["name"]
        icon = row["icon_name"]
        condition = row["condition"]
        rank = (row["rank"] as String == "LR") ? .low : .high
        stackSize = row["stack_size"]
        chance = row["percentage"]
    }
}

class MonsterDamageByPart {
    var state = "Normal"
    var damage = [MonsterDamage]()
}

class MonsterDamage: RowConvertible {
    var bodyPart: String
    var cut: Int
    var impact: Int
    var shot: Int
    var fire: Int
    var water: Int
    var ice: Int
    var thunder: Int
    var dragon: Int
    var ko: Int
    
    required init(row: Row) {
        bodyPart = row["body_part"]
        cut = row["cut"]
        impact = row["impact"]
        shot = row["shot"]
        fire = row["fire"]
        water = row["water"]
        ice = row["ice"]
        thunder = row["thunder"]
        dragon = row["dragon"]
        ko = row["ko"]
    }
}

class MonsterStatus: RowConvertible {
    var row: Row
    var status: String
    var initial: Int
    var increase: Int
    var max: Int
    var duration: Int
    var damage: Int
    
    required init(row: Row) {
        self.row = row.copy()
        status = row["status"]
        initial = row["initial"]
        increase = row["increase"]
        max = row["max"]
        duration = row["duration"]
        damage = row["damage"]
    }
}

class MonsterStatusValues {
    var stat: String
    var poison: Int
    var sleep: Int
    var paralysis: Int
    var ko: Int
    var exhaust: Int
    var mount: Int
    var jump: Int
    var blast: Int
    
    // This is ugly
    required init(values: [String: Row], column: String) {
        stat = column
        poison = MonsterStatusValues.getValue(values: values, column: column, stat: "Poison")
        sleep = MonsterStatusValues.getValue(values: values, column: column, stat: "Sleep")
        paralysis = MonsterStatusValues.getValue(values: values, column: column, stat: "Para")
        ko = MonsterStatusValues.getValue(values: values, column: column, stat: "KO")
        exhaust = MonsterStatusValues.getValue(values: values, column: column, stat: "Exhaust")
        mount = MonsterStatusValues.getValue(values: values, column: column, stat: "Mount")
        jump = MonsterStatusValues.getValue(values: values, column: column, stat: "Jump")
        blast = MonsterStatusValues.getValue(values: values, column: column, stat: "Blast")
    }
    
    class func getValue(values: [String: Row], column: String, stat: String) -> Int {
        if let row = values[stat] {
            return row[column] ?? -1
        } else {
            return 0
        }
    }
}

extension Database {
    func monster(id: Int) -> Monster {
        let query = "SELECT * FROM monsters WHERE _id = \(id)"
        return fetch(query)[0]
    }
    
    func monsters(_ search: String? = nil, size: Monster.Size? = nil) -> [Monster] {
        let query = "SELECT * FROM monsters"
        let order = "ORDER BY sort_name"
        
        if let size = size {
            switch size {
            case .small:
                return fetch(select: query, order: order, filter: "class = 1")
            case .large:
                return fetch(select: query, order: order, filter: "class = 0")
            }
        } else {
            return fetch(select: query, order: order, search: search)
        }
    }
    
    func monsterStatus(monsterId: Int) -> [MonsterStatus] {
        let query = "SELECT * FROM monster_status WHERE monster_id = \(monsterId)"
        return fetch(query)
    }
    
    func monsterAilments(monsterId: Int) -> [String] {
        let query = "SELECT ailment FROM monster_ailment WHERE monster_id = \(monsterId)"
        return getStrings(query, column: "ailment")
    }
    
    func monsterDamage(monsterId: Int) -> [MonsterDamage] {
        let query = "SELECT * FROM monster_damage WHERE monster_id = \(monsterId)"
        return fetch(query)
    }
    
    func weaknesses(forMonsterId: Int) -> [Weaknesses] {
        let query = "SELECT * FROM monster_weakness "
            + "WHERE monster_id == '\(forMonsterId)' ORDER BY _id ASC"
        return fetch(query)
    }
    
    func habitats(monsterId: Int) -> [MonsterHabitat] {
        let query = "SELECT *,"
            + " locations._id AS locationid,"
            + " locations.name AS locationname,"
            + " locations._id AS locationid"
            + " FROM monster_habitat"
            + " LEFT JOIN locations on monster_habitat.location_id = locations._id"
            + " LEFT JOIN monsters on monster_habitat.monster_id = monsters._id"
            + " WHERE monsters._id == \(monsterId)"
        return fetch(query)
    }
    
    func rewards(monsterId: Int, rank: Quest.Rank) -> [MonsterReward] {
        let query = "SELECT *,"
            + " items._id AS itemid,"
            + " items.name as name,"
            + " items.icon_name as icon_name"
            + " FROM hunting_rewards"
            + " LEFT JOIN items on hunting_rewards.item_id = items._id"
            + " LEFT JOIN monsters on hunting_rewards.monster_id = monsters._id"
            + " WHERE monsters._id == \(monsterId)"
            + " AND rank == '\(rank.rawValue)'"
            + " ORDER BY condition, percentage DESC"
        return fetch(query)
    }
    
    func quests(monsterId: Int) -> [MonsterQuest] {
        let query = "SELECT *,"
            + " quests.name AS questname,"
            + " quests._id AS questid"
            + " FROM monster_to_quest"
            + " LEFT JOIN quests on monster_to_quest.quest_id = quests._id"
            + " LEFT JOIN monsters on monster_to_quest.monster_id = monsters._id"
            + " WHERE monsters._id == \(monsterId)"
        return fetch(query)
    }
}
