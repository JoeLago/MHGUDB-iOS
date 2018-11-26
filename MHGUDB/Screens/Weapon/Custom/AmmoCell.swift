//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation

class AmmoCell: GridCell<Weapon> {
    
    override var model: Weapon? {
        didSet {
            if let model = model {
                setup(weapon: model)
            }
        }
    }
    
    func setup(weapon: Weapon) {
        guard let ammo = weapon.ammo else {
            return
        }
        
        add(values: ["Lvl", 1, 2, 3, " ", 1, 2, " ", " "])
        add(values: ["Normal", ammo.normal1, ammo.normal2, ammo.normal3,
                     "Poison", ammo.poison1, ammo.poison2,
                     "Fire", ammo.fire])
        add(values: ["Peirce", ammo.pierce1, ammo.pierce2, ammo.pierce3,
                     "Paralysis", ammo.paralysis1, ammo.paralysis2,
                     "Water", ammo.water])
        add(values: ["Pellet", ammo.pellet1, ammo.pellet2, ammo.pellet3,
                     "Sleep", ammo.sleep1, ammo.sleep2,
                     "Thunder", ammo.thunder])
        add(values: ["Crag", ammo.crag1, ammo.crag2, ammo.crag3,
                     "Exhaust", ammo.exhaust1, ammo.exhaust2,
                     "Ice", ammo.ice])
        add(values: ["Clust", ammo.clust1, ammo.clust2, ammo.clust3,
                     "", "", "",
                     "Dragon", ammo.dragon])
    }
}
