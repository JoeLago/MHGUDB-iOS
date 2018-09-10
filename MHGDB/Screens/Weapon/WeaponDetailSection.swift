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
        addDetail(label: "Description", text: weapon.description)
        
        addCell(MultiDetailCell(details: [
            SingleDetailLabel(label: "Create Cost", value: weapon.creationCost),
            SingleDetailLabel(label: "Upgrade Cost", value: weapon.upgradeCost)
            ]))
        
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
        
        if let notes = weapon.noteImageNames {
          let model = ImageLabelCellModel(values: notes.compactMap { ImageLabelModel($0) }, label: "Notes")
            addCell(ImageLabelCell<ImageLabelCellModel>(model: model))
        }
        
        if let coatings = weapon.coatingImageNames {
          let model = ImageLabelCellModel(values: coatings.compactMap { ImageLabelModel($0) }, label: "Coatings")
            addCell(ImageLabelCell<ImageLabelCellModel>(model: model))
        }
        
        if let charges = weapon.charges?.components(separatedBy: "|") {
            addDetail(label: "Charges", text: charges.joined(separator: ", "))
        }
    }
}
