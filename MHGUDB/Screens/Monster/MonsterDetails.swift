//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class MonsterDetails: DetailController, DetailScreen {
    var id: Int
    
    convenience init(id: Int) {
        self.init(Database.shared.monster(id: id))
    }
    
    init(_ monster: Monster) {
        id = monster.id
        super.init()
        title = monster.name
        addSimpleSection(data: [monster])
        
        add(section: MonsterDetailSection(monster: monster))
        addSimpleSection(data: monster.habitats, title: "Habitats") { LocationDetails(id: $0.locationId) }
        addCustomSection(title: "Weaknesses", data: monster.weaknesses, cellType: ImageLabelCell.self)
        addCustomSection(title: "Damage", data: monster.damageByPart, cellType: MonsterDamagesCell.self, showCount: false)
        addCustomSection(title: "Status Effects", data: [monster], cellType: MonsterStatusesCell.self)
        addSimpleSection(data: monster.quests, title: "Quests") { QuestDetails(id: $0.questId) }
        addRewardSection(monster: monster, rank: .low, title: "Low Rank Rewards")
        addRewardSection(monster: monster, rank: .high, title: "High Rank Rewards")
        addRewardSection(monster: monster, rank: .g, title: "G Rank Rewards")
    }
    
    func addRewardSection(monster: Monster, rank: Quest.Rank, title: String) {
        let rewards = monster.rewardsByCondition(rank: rank)
        let sections = [SimpleDetailSection](rewards.keys.map
        { SimpleDetailSection(data: rewards[$0]!, title: $0, showCountMinRows: -1)
        { self.push(ItemDetails(id: $0.itemId)) } })
        add(section: SubSection(subSections: sections, title: title))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("I don't want to use storyboards Apple")
    }
}

extension MonsterReward: DetailCellModel {
    var primary: String? { return name + (stackSize ?? 0 > 1 ? " x\(stackSize ?? 0)": "") }
    var secondary: String? { return "\(Int(chance ?? 0))%" }
}

extension MonsterHabitat: DetailCellModel {
    var primary: String? { return location }
    var secondary: String? { return string }
}


extension MonsterQuest: DetailCellModel {
    var primary: String? { return questName }
    var subtitle: String? { return "\(stars)\(String.star) \(hub)" }
}

extension Weaknesses: ImageLabelCellProtocol {
    var label: String? {
        if let state = state {
            return state + " State"
        } else {
            return nil
        }
    }
    
    var values: [ImageLabelModel] {
        return [
            ImageLabelModel("Fire.png", value: fire),
            ImageLabelModel("Water.png", value: water),
            ImageLabelModel("Thunder.png", value: thunder),
            ImageLabelModel("Ice.png", value: ice),
            ImageLabelModel("Dragon.png", value: dragon),
            ImageLabelModel("Poison.png", value: poison),
            ImageLabelModel("Paralysis", value: paralysis),
            ImageLabelModel("Sleep.png", value: sleep),
            ImageLabelModel("Trap-Green.png", value: pitfallTrap, doShowValue: false),
            ImageLabelModel("Traptool-Yellow.png", value: shockTrap, doShowValue: false),
            ImageLabelModel("Bomb-Yellow.png", value: flashBomb, doShowValue: false),
            ImageLabelModel("Bomb-White.png", value: sonicBomb, doShowValue: false),
            ImageLabelModel("Dung.png", value: dungBomb, doShowValue: false),
            ImageLabelModel("Meat-Red.png", value: meat, doShowValue: false)
        ]
    }
}
