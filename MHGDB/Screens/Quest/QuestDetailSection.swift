//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class QuestDetailSection: MultiCellSection {
    var quest: Quest
    
    init(quest: Quest) {
        self.quest = quest
        super.init()
        title = "Details"
    }
    
    override func populateCells() {
        addCell(MultiDetailCell(details: [
            SingleDetailLabel(label: "Hub", value: "\(quest.stars)\(String.star) \(quest.hub ?? "")"),
            SingleDetailLabel(label: "Fee", value: quest.fee),
            SingleDetailLabel(label: "Reward", value: quest.reward),
            SingleDetailLabel(label: "HRP", value: quest.hrp)
            ]))
        
        if quest.hasSubQuest {
            addDetail(label: "Subquest", text: quest.subQuest)
            addCell(MultiDetailCell(details: [
                SingleDetailLabel(label: "Sub Reward", value: quest.subReward),
                SingleDetailLabel(label: "Sub HRP", value: quest.subHrp)
                ]))
        }
        
        addDetail(label: "Description", text: quest.description)
    }
}
