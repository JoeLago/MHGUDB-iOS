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
        isToolBarHidden = false
        addSimpleSection(data: [armor])
        addSimpleSection(data: armor.skills, title: "Skills") { SkillDetails(id: $0.skillId) }
        addCustomSection(title: "Resistances", data: [armor.resistances], cellType: ImageLabelCell.self)
        addSimpleSection(data: armor.components, title: "Components") { ItemDetails(id: $0.itemId) }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateToolbar()
    }

    @objc func addToFavorites() {
        Database.shared.bookmarkItem(id: id)
        updateToolbar()
    }

    func updateToolbar() {
        let isBookmarked = Database.shared.isBookmarked(itemId: id)
        let bookmarkIconName = isBookmarked ? "bookmark-selected" : "bookmark"
        let addButton = UIBarButtonItem(image: UIImage(named: bookmarkIconName), style: .plain, target: self, action: #selector(addToFavorites))
        toolbarItems = [UIBarButtonItem.flexible(), addButton]
    }
}

extension ArmorSkill: DetailCellModel {
    var primary: String? { return name }
    var secondary: String? { return "\(value)" }
}

extension ArmorComponent: DetailCellModel {
    var primary: String? { return name }
    var secondary: String? { return "x \(quantity ?? 0)" }
}

extension Resistances: ImageLabelCellProtocol {
    var label: String? { return nil }
    
    var values: [ImageLabelModel] {
        return [
            ImageLabelModel("Fire.png", value: fire),
            ImageLabelModel("Water.png", value: water),
            ImageLabelModel("Thunder.png", value: thunder),
            ImageLabelModel("Ice.png", value: ice),
            ImageLabelModel("Dragon.png", value: dragon)
        ]
    }
}
