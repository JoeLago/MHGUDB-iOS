//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class WeaponTypeList: SimpleTableViewController {
    override func loadView() {
        super.loadView()
        
        for weaponType in Weapon.WType.allValues {
            addWeapon(weaponType: weaponType)
        }
    }
    
    func addWeapon(weaponType: Weapon.WType) {
        addCell(text: weaponType.rawValue, imageName: weaponType.imageName, selectedBlock: { () in
            self.push(viewController: WeaponList(weaponType: weaponType))
        })
    }
}
