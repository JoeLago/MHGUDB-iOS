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
            "icon_great_sword".attributedImage,
            "icon_hammer".attributedImage,
            "icon_heavy_bowgun".attributedImage,
            "Fire".attributedImage,
            "Water".attributedImage,
            "Ice".attributedImage,
            "Thunder".attributedImage,
            "Dragon".attributedImage,
            "Stun".attributedImage,
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
