//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation

class MonsterDamagesCell: GridCell<MonsterDamageByPart> {
    
    override var model: MonsterDamageByPart? {
        didSet {
            if let model = model {
                populate(damages: model)
            }
        }
    }
    
    func populate(damages: MonsterDamageByPart) {
        add(values: [
            damages.state.bold,
            "great_sword1.png".attributedImage,
            "hammer1.png".attributedImage,
            "heavy_bowgun1.png".attributedImage,
            "Fire.png".attributedImage,
            "Water.png".attributedImage,
            "Ice.png".attributedImage,
            "Thunder.png".attributedImage,
            "Dragon.png".attributedImage,
            "Stun.png".attributedImage,
            ])
        
        
        for damage in damages.damage {
            add(values: [
                damage.bodyPart,
                damage.cut,
                damage.impact,
                damage.shot,
                damage.fire,
                damage.water,
                damage.ice,
                damage.thunder,
                damage.dragon,
                damage.ko,
                ])
        }
    }
}
