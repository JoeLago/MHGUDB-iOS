//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation

class MonsterStatusesCell: GridCell<Monster> {
    
    override var model: Monster? {
        didSet {
            if let model = model {
                populate(monster: model)
            }
        }
    }
    
    func populate(monster: Monster) {
        add(imageNames: ["",
                         "Poison",
                         "Sleep",
                         "Paralysis",
                         "Stun",
                         "exhaust",
                         "mount",
                         "jump",
                         "BlastBlight"])
        
        for status in monster.statuses {
            let values: [Any] = [status.stat.capitalizingFirstLetter(),
                                 status.poison,
                                 status.sleep,
                                 status.paralysis,
                                 status.ko,
                                 status.exhaust,
                                 status.mount,
                                 status.jump,
                                 status.blast]
            add(values: values)
        }
    }
}
