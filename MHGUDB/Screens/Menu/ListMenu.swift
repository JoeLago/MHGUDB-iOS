//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class ListMenu: SimpleTableViewController {
    var searchController: SearchAllController!
    
    override func loadView() {
        super.loadView()
        title = "MHGUDB"
        
        definesPresentationContext = true
        searchController = SearchAllController(mainViewController: self)
        
        if #available(iOS 11, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        
        addCell(text: "Quests", icon: Icon(name: "icon_quest.png", color: .red)) { QuestList() }
        addCell(text: "Monsters", icon: Icon(name: "monster_rathalos.png")) { MonsterList() }
        addCell(text: "Weapons", icon: Icon(name: "icon_great_sword.png", color: .cyan)) { WeaponTypeList() }
        addCell(text: "Armor", icon: Icon(name: "icon_armor_body.png", color: .pink)) { ArmorList() }
        addCell(text: "Items", icon: Icon(name: "icon_ore.png", color: .purple)) { ItemList() }
        addCell(text: "Combinations", icon: Icon(name: "icon_liquid.png", color: .green)) { CombinationList() }
        addCell(text: "Locations", icon: Icon(name: "icon_map_icon.png", color: .white)) { LocationList() }
        addCell(text: "Decorations", icon: Icon(name: "icon_jewel.png", color: .cyan)) { DecorationList() }
        addCell(text: "Skills", icon: Icon(name: "icon_monster_jewel.png", color: .teal)) { SkillList() }
        addCell(text: "Palico", icon: Icon(name: "icon_cutting.png", color: .yellow)) { PalicoList() }
        addCell(text: "Bookmarks", icon: Icon(name: "icon_mantle.png", color: .gold)) { BookmarksScreen() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 10.3, *) {
            ReviewManager.presentReviewControllerIfElligible()
        }
    }
}
