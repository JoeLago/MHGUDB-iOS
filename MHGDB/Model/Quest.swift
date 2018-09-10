//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation
import GRDB

class Quest: RowConvertible {
    var id: Int!
    var name: String?
    var hub: String? // Switch to enum
    var icon: String?
    var goal: String?
    var goalType: Quest.Goal?
    var progression: Quest.Progression?
    var stars: Int
    var subQuest: String?
    var reward: Int?
    var hrp: Int?
    var description: String?
    var subReward: Int?
    var subHrp: Int?
    var fee: Int?
    var hasSubQuest = false
    
    enum Rank: String {
        case low = "LR"
        case high = "HR"
        case g = "G"
    }
    
    enum Hub: String {
        case village = "Village"
        case arena = "Arena"
        case event = "Event"
        case guild = "Guild"
        case permit = "Permit"
    }
    
    enum Progression {
        case normal, key, urgent
        
        init?(_ type: Int?) {
            if type == nil {
                return nil
            }
            
            switch type! {
            case 0: self = .normal
            case 1: self = .key
            case 2: self = .urgent
            default: return nil
            }
        }
        
        var text: String {
            get {
                switch self {
                case .normal: return "Normal"
                case .key: return "Key"
                case .urgent: return "Urgent"
                }
            }
        }
    }
    
    enum Goal {
        case hunt, slay, capture, deliver, huntathon, marathon
        
        init?(_ type: Int?) {
            if type == nil {
                return nil
            }
            
            switch type! {
            case 0: self = .hunt
            case 1: self = .slay
            case 2: self = .capture
            case 3: self = .deliver
            case 4: self = .huntathon
            case 5: self = .marathon
            default: return nil
            }
        }
        
        var text: String? {
            get {
                switch self {
                case .hunt: return "Hunt"
                case .slay: return "Slay"
                case .capture: return "Capture"
                case .deliver: return "Deliver"
                case .huntathon: return "Huntathon"
                case .marathon: return "Marathon"
                }
            }
        }
    }
    
    class func titleForStars(count: Int) -> String {
        if count == 0 {
            return "Training"
        }
        
        var title = "\(count) "
        for _ in 0 ... count - 1 {
            title += String.star
        }
        return title
    }
    
    lazy var rewards: [QuestReward] = {
        return Database.shared.rewards(questId: self.id)
    }()
    
    lazy var prereqQuests: [Quest] = {
        return Database.shared.prereqQuests(questId: self.id)
    }()
    
    lazy var rewardsBySlot: [String: [QuestReward]] = {
        let allRewards = Database.shared.rewards(questId: self.id)
        var rewardsBySlot = [String: [QuestReward]]()
        for reward in allRewards {
            var slot = rewardsBySlot[reward.slot] ?? [QuestReward]()
            slot.append(reward)
            rewardsBySlot[reward.slot] = slot
        }
        return rewardsBySlot
    }()
    
    lazy var monsters: [QuestMonster] = {
        return Database.shared.monsters(questId: self.id)
    }()
    
    required init(row: Row) {
        id = row["_id"]
        name = row["name"]
        icon = row["icon_name"]
        goal = row["goal"]
        goalType = Quest.Goal(row["goal_type"]) // TODO enum inferrence
        hub = row["hub"]
        progression = Quest.Progression(Int(row["type"] as String)) // TODO enum inferrence
        stars = row["stars"]
        reward = row["reward"]
        hrp = row["hrp"]
        subQuest = row["sub_goal"]
        subReward = row["sub_reward"]
        subHrp = row["sub_hrp"]
        description = row["flavor"]
        fee = row["fee"]
        hasSubQuest = subQuest != "None"
    }
}

class QuestReward: RowConvertible {
    let itemId: Int
    var name: String
    var icon: String?
    var quantity: Int
    var chance: Int
    var slot: String
    
    required init(row: Row) {
        itemId = row["itemid"]
        name = row["itemname"]
        icon = row["itemicon"]
        quantity = row["quantity"] ?? 0
        chance = row["percentage"] ?? 0
        slot = row["reward_slot"]
    }
}

class QuestMonster: RowConvertible {
    let monsterId: Int
    let name: String
    var startArea: String?
    var moveArea: String?
    var restArea: String?
    var locations: String {
      return [startArea, moveArea, restArea].compactMap{ $0 }.joined(separator: " > ")
    }
    let icon: String?
    
    required init(row: Row) {
        monsterId = row["monsterid"]
        name = row["monstername"]
        icon = row["monstericon"]
        startArea = row["start_area"]
        moveArea = row["move_area"]
        restArea = row["rest_area"]
    }
}

extension Database {
    
    func quest(id: Int) -> Quest {
        let query = "SELECT * FROM quests WHERE _id = \(id)"
        return fetch(query)!
    }
    
    func quests(_ search: String? = nil, keyOnly: Bool = false, hub: String? = nil,
                stars: Int? = nil) -> [[Quest]] {
        let query = "SELECT * FROM quests"
        let order = "ORDER BY stars"
        var filters = [String]()
        
        if let hub = hub {
            filters.append("hub == '\(hub)'")
        }
        
        if let stars = stars {
            filters.append("stars == \(stars)")
        }
        
        if (keyOnly) {
            filters.append("type != 0")
        }
        
        let filter = filters.joined(separator: " AND ")
        
        let quests = fetch(select: query, order: order, filter: filter, search: search) as [Quest]
        
        if search != nil {
            return [quests]
        }
        
        // Meh
        var questGroups = [[Quest]]()
        var questsPerStar = [Quest]()
        for quest in quests {
            if questsPerStar.count > 0 && quest.stars != questsPerStar.first!.stars {
                questGroups.append(questsPerStar)
                questsPerStar = [quest]
            } else {
                questsPerStar.append(quest)
            }
        }
        
        questGroups.append(questsPerStar)
        
        return questGroups
    }
    
    func questHubs() -> [String] {
        return getStrings("SELECT hub as value FROM quests GROUP BY hub")
    }
    
    var rewardsQuery: String {
        return "SELECT *,"
            + " items._id AS itemid,"
            + " items.name AS itemname,"
            + " items._id AS itemid,"
            + " items.icon_name AS itemicon,"
            + " quests.name AS questname,"
            + " quests._id AS questid"
            + " FROM quest_rewards"
            + " LEFT JOIN items on quest_rewards.item_id = items._id"
            + " LEFT JOIN quests on quest_rewards.quest_id = quests._id "
    }
    
    func rewards(questId: Int) -> [QuestReward] {
        let query = rewardsQuery + "WHERE quests._id == \(questId)"
        return fetch(query)
    }
    
    func monsters(questId: Int) -> [QuestMonster] {
        // The monster_habitat night locations use day counterpart id 100 off
        let query = "SELECT *,"
            + " monsters._id AS monsterid,"
            + " monsters.name AS monstername,"
            + " monsters.icon_name as monstericon"
            + " FROM monster_to_quest"
            + " LEFT JOIN quests on monster_to_quest.quest_id = quests._id"
            + " LEFT JOIN monsters on monster_to_quest.monster_id = monsters._id"
            + " LEFT JOIN monster_habitat on monster_habitat.monster_id = monsters._id"
            + " AND (monster_habitat.location_id = quests.location_id OR monster_habitat.location_id = quests.location_id - 100)"
            + " WHERE quests._id == \(questId)"
        return fetch(query)
    }
    
    func prereqQuests(questId: Int) -> [Quest] {
        let query = "SELECT *, quest_prereqs.prereq_id as _id FROM quest_prereqs"
            + " LEFT JOIN quests ON quests._id = quest_prereqs.prereq_id"
            + " WHERE quest_id == \(questId)"
        return fetch(query)
    }
}
