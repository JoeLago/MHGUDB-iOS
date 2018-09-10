//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class ArmorDetails: DetailController, DetailScreen {
    var id: Int
    
    convenience init(id: Int) {
        self.init(Database.shared.armor(id: id))
    }
    
    init(_ armor: Armor) {
        id = armor.id
        super.init()
        title = armor.name
        addSimpleSection(data: [armor])
        addSimpleSection(data: armor.skills, title: "Skills") { SkillDetails(id: $0.skillId) }
        addCustomSection(title: "Resistances", data: [armor.resistances], cellType: ImageLabelCell.self)
        addSimpleSection(data: armor.components, title: "Components") { ItemDetails(id: $0.itemId) }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ArmorSkill: DetailCellModel {
    var primary: String? { return name }
    var secondary: String? { return "\(value)" }
}

extension ArmorComponent: DetailCellModel {
    var primary: String? { return name }
    var imageName: String? { return icon }
    var secondary: String? { return "x \(quantity ?? 0)" }
    // TODO: Do we need this?  Create/Upgrade should get there own sections, armor is only create?
    //var subtitle: String? { return type }
}

extension Resistances: ImageLabelCellProtocol {
    var label: String? { return nil }
    
    var values: [ImageLabelModel] {
        return [
            ImageLabelModel("Fire.png", fire),
            ImageLabelModel("Water.png", water),
            ImageLabelModel("Thunder.png", thunder),
            ImageLabelModel("Ice.png", ice),
            ImageLabelModel("Dragon.png", dragon)
        ]
    }
}
