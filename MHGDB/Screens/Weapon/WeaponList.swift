//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class WeaponList: DetailController {
    
    init(weaponType: Weapon.WType) {
        super.init()
        title = weaponType.rawValue
        let weapons = TreeSection<Weapon, WeaponView>(tree: Database.shared.weaponTree(type: weaponType)!) {
            self.push(WeaponDetails(id: $0.id))
        }
        add(section: weapons)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("I don't want to use storyboards Apple")
    }
}
