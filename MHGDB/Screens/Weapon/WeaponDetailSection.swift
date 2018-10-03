//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class WeaponDetailSection: MultiCellSection {
    var weapon: Weapon
    
    init(weapon: Weapon) {
        self.weapon = weapon
        super.init()
        title = "Details"
    }
    
    override func populateCells() {
        
        addCell(MultiDetailCell(details: [
            SingleDetailLabel(label: "Affinity", value: "\(weapon.affinity ?? 0)%"),
            weapon.creationCost ?? 0 > 0 ? SingleDetailLabel(label: "Create Cost", value: weapon.creationCost) : nil,
            weapon.upgradeCost ?? 0 > 0 ? SingleDetailLabel(label: "Upgrade Cost", value: weapon.upgradeCost) : nil
            ].compactMap { $0 }))
        
        if weapon.reloadSpeed != nil {
            addCell(MultiDetailCell(details: [
                SingleDetailLabel(label: "Recoil", value: weapon.recoil),
                SingleDetailLabel(label: "Reload Speed", value: weapon.reloadSpeed),
                SingleDetailLabel(label: "Deviation", value: weapon.deviation)
                ]))
        } else {
            addDetail(label: "Recoil", text: weapon.recoil)
        }
        
        addDetail(label: "Shelling Type", text: weapon.shellingType)
        
        if let phial = weapon.phial {
            addDetail(label: "Phial", text:"\(phial)\(weapon.phialAttack != nil ? " \(weapon.phialAttack ?? 0)": "")")
        }

        if let notes = weapon.noteIcons {
            let model = ImageLabelCellModel(values: notes.compactMap { ImageLabelModel(icon: $0) }, label: "Notes")
            addCell(ImageLabelCell<ImageLabelCellModel>(model: model))
        }

        if let coatings = weapon.coatingIcons {
            let model = ImageLabelCellModel(values: coatings.compactMap { ImageLabelModel(icon: $0) }, label: "Coatings")
            addCell(ImageLabelCell<ImageLabelCellModel>(model: model))
        }
        
        if let charges = weapon.charges?.components(separatedBy: "|") {
            addDetail(label: "Charges", text: charges.joined(separator: ", "))
        }
    }
}
