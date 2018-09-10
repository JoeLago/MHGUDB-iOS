//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class ArmorList: DetailController {
    var type = Armor.HunterType.all
    var slot = Armor.Slot.body
    
    override func loadView() {
        super.loadView()
        
        title = "Armor"
        isToolBarHidden = false
        populateSections()
        
        let typeButton = addButton(
            title: type.string, options: Armor.HunterType.allStringValues,
            selected: { (index: Int, value: String) in
                self.type = Armor.HunterType.forString(value) ?? .all
                self.reloadData()
        })
        
        let slotButton = addButton(
            title: slot.rawValue, options: Armor.Slot.allStringValues,
            selected: { (index: Int, value: String) in
                self.slot = Armor.Slot.forString(value) ?? .body
                self.reloadData()
        })
        
        let flexibleSpace = UIBarButtonItem.flexible()
        toolbarItems = [flexibleSpace, typeButton, slotButton, flexibleSpace]
    }
    
    override func reloadData() {
        populateSections()
        tableView.reloadData()
    }
    
    func populateSections() {
        sections.removeAll()
        
        let armor = Database.shared.armor(hunterType: type, slot: slot)
        addSimpleSection(data: armor) { ArmorDetails(id: $0.id) }
    }
}

extension Armor: DetailCellModel {
    var primary: String? { return name }
    var subtitle: String? { return slotsString }
    var secondary: String? { return "\(defense) - \(defenseMax) def" }
    var imageName: String? { return icon }
}

