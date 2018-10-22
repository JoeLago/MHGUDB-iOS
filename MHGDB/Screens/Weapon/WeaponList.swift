//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class WeaponList: DetailController {
    var weaponType: Weapon.WType
    var doShowFinal = false
    var finalButton: UIBarButtonItem = UIBarButtonItem(customView: UIView())
    
    init(weaponType: Weapon.WType) {
        self.weaponType = weaponType
        super.init()
        title = weaponType.rawValue
        isToolBarHidden = false
        populateSections()
    }

    override func loadView() {
        super.loadView()
        finalButton = UIBarButtonItem(title: "Final Only", style: .plain,
                                         target: self, action: #selector(toggleFinalButton))
        toolbarItems = [UIBarButtonItem.flexible(), finalButton]
    }

    @objc func toggleFinalButton() {
        doShowFinal = !doShowFinal
        finalButton.style = doShowFinal ? .done : .plain
        populateSections()
    }

    func populateSections() {
        sections.removeAll()

        if doShowFinal {
            let weapons = Database.shared.finalWeapons(type: self.weaponType)
            let section = CustomSection(cellType: WeaponCell.self, data: weapons) {
                self.push(WeaponDetails(id: $0.id))
            }
            add(section: section)
        } else {
            let weapons = TreeSection<Weapon, WeaponView>(tree: Database.shared.weaponTree(type: weaponType)!) {
                self.push(WeaponDetails(id: $0.id))
            }
            add(section: weapons)
        }

        reloadData()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("I don't want to use storyboards Apple")
    }
}
