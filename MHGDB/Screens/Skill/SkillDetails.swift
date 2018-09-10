//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class SkillDetails: DetailController, DetailScreen {
    var id: Int
    
    convenience required init(id: Int) {
        self.init(skillTree: Database.shared.skillTree(id: id))
    }
    
    init(skillTree: SkillTree) {
        id = skillTree.id
        super.init()
        title = skillTree.name
        addSimpleSection(data: skillTree.skills, title: "Skills")
        addSimpleSection(data: skillTree.decorations, title: "Decorations") { DecorationDetails(id: $0.itemId) }
        addSimpleSection(data: skillTree.weapons, title: "Weapons") { WeaponDetails(id: $0.itemId) }
        addSimpleSection(data: skillTree.armor(slot: .head), title: "Head") { ArmorDetails(id: $0.itemId) }
        addSimpleSection(data: skillTree.armor(slot: .body), title: "Body") { ArmorDetails(id: $0.itemId) }
        addSimpleSection(data: skillTree.armor(slot: .arms), title: "Arms") { ArmorDetails(id: $0.itemId) }
        addSimpleSection(data: skillTree.armor(slot: .waist), title: "Waist") { ArmorDetails(id: $0.itemId) }
        addSimpleSection(data: skillTree.armor(slot: .legs), title: "Legs") { ArmorDetails(id: $0.itemId) }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Skill: DetailCellModel {
    var primary: String? { return name }
    var subtitle: String? { return description }
    var secondary: String? { return "\(points)" }
    var imageName: String? { return nil }
}

extension SkillItem: DetailCellModel {
    var primary: String? { return name }
    var subtitle: String? { return nil }
    var secondary: String? { return "\(points)" }
    var imageName: String? { return icon }
}
