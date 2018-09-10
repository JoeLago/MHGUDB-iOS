//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class PalicoWeaponDetails: DetailController, DetailScreen {
    var id: Int
    
    convenience required init(id: Int) {
        self.init(weapon: Database.shared.palicoWeapon(id: id))
    }
    
    init(weapon: PalicoWeapon) {
        id = weapon.id
        super.init()
        title = weapon.name
        addSimpleSection(data: [weapon])
        add(section: PalicoWeaponDetailSection(weapon: weapon))
        addSimpleSection(data: weapon.components, title: "Components") { ItemDetails(id: $0.id) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("I don't want to use storyboards Apple")
    }
}
