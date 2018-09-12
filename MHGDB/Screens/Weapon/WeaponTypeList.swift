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
        let icon = Icon(name: weaponType.imageName)
        addCell(text: weaponType.rawValue, icon: icon, selectedBlock: { () in
            self.push(viewController: WeaponList(weaponType: weaponType))
        })
    }
}
