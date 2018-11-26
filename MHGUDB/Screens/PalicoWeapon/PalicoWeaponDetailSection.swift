//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class PalicoWeaponDetailSection: MultiCellSection {
    var weapon: PalicoWeapon
    
    init(weapon: PalicoWeapon) {
        self.weapon = weapon
        super.init()
        title = "Details"
    }
    
    override func populateCells() {
        let sharpnessView = SharpnessView()
        sharpnessView.sharpness = weapon.sharpness
        sharpnessView.heightConstraint(10)
        let sharpnessDetail = SingleDetailView(label: "Sharpness", detailView: sharpnessView)
        
        addCell(MultiDetailCell(details: [
            SingleDetailLabel(label: "Melee Dmg",
                              attributedString:
                NSMutableAttributedString(damage: weapon.attackMelee,
                                          element: weapon.element,
                                          elementDamage: weapon.elementMelee)),
            SingleDetailLabel(label: "Ranged Dmg",
                              attributedString:
                NSMutableAttributedString(damage: weapon.attackRanged,
                                          element: weapon.element,
                                          elementDamage: weapon.elementRanged)),
            sharpnessDetail
            ]))
        
        addCell(MultiDetailCell(details: [
            SingleDetailLabel(label: "Type", value: weapon.type),
            SingleDetailLabel(label: "Balance", value: weapon.balance.string),
            SingleDetailLabel(label: "Create Cost", value: weapon.creationCost),
            ]))
        addDetail(label: "Description", text: weapon.description)
    }
}
