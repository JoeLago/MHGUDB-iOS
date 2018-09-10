//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class MonsterDetailSection: MultiCellSection {
    var monster: Monster
    
    init(monster: Monster) {
        self.monster = monster
        super.init()
        title = "Details"
    }
    
    override func populateCells() {
        addDetail(label: "Ailments", text: monster.ailments()?.joined(separator: ", "))
    }
}
