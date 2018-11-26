//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class WeaponDetails: DetailController, DetailScreen {
    var id: Int
    
    convenience init(id: Int) {
        self.init(Database.shared.weapon(id: id))
    }
    
    init(_ weapon: Weapon) {
        id = weapon.id
        super.init()
        title = weapon.name
        isToolBarHidden = false
        addCustomSection(data: [weapon], cellType: WeaponCell.self)
        add(section: WeaponDetailSection(weapon: weapon))
        
        if weapon.ammo != nil {
            addCustomSection(title: "Ammo", data: [weapon], cellType: AmmoCell.self)
        }
        
        addSimpleSection(data: weapon.components, title: "Components") { ItemDetails(id: $0.id) }
        
        let result = Database.shared.weaponTree(weaponId: weapon.id)
        let path = TreeSection<Weapon, WeaponView>(tree: result.1) {
            self.push(WeaponDetails(id: $0.id))
        }
        path.selectedNode = result.0
        path.title = "Path"
        add(section: path)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("I don't want to use storyboards Apple")
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

extension Component: DetailCellModel {
    var primary: String? { return name }
    var subtitle: String? { return type }
    var secondary: String? { return "x \(quantity)" }
}
