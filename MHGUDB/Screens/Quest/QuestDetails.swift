//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class QuestDetails: DetailController, DetailScreen {
    var id: Int
    
    convenience required init(id: Int) {
        self.init(quest: Database.shared.quest(id: id))
    }
    
    init(quest: Quest) {
        id = quest.id
        super.init()
        title = quest.name
        addSimpleSection(data: [quest])
        add(section: QuestDetailSection(quest: quest))
        addSimpleSection(data: quest.prereqQuests, title: "Prerequisite Quests") { QuestDetails(id: $0.id) }
        addSimpleSection(data: quest.monsters, title: "Monsters") { MonsterDetails(id: $0.monsterId) }
        
        let rewardsBySlot = quest.rewardsBySlot
        for slot in rewardsBySlot.keys.sorted() {
            let rewards = rewardsBySlot[slot]!
            addSimpleSection(data: rewards, title: "\(slot) Slot Rewards") { ItemDetails(id: $0.itemId) }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension QuestMonster: DetailCellModel {
    var primary: String? { return name }
    var subtitle: String? { return locations }
}

extension QuestReward: DetailCellModel {
    var primary: String? { return name + (quantity > 0 ? " \(quantity)" : "") }
    var subtitle: String? { return nil }
    var secondary: String? { return "\(Int(chance))%" }
}
