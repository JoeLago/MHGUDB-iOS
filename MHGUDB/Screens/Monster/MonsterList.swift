//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class MonsterList: DetailController {
    var monsterSection: SimpleDetailSection<Monster>!
    var segment: UISegmentedControl!

    var monsterSize: Monster.Size? {
        didSet {
            monsterSection.rows = Database.shared.monsters(size: monsterSize)
        }
    }

    var selectedSize: Monster.Size? {
        get {
            switch segment.selectedSegmentIndex {
            case 0: return .large
            case 1: return .deviant
            case 2: return .small
            default: return nil
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        
        title = "Monsters"
        
        monsterSection = SimpleDetailSection(data: Database.shared.monsters(size: .large)) {
            [unowned self] (model: Monster) in
            self.push(MonsterDetails(id: model.id))
        }
        add(section: monsterSection)
        
        segment = populateToolbarSegment(items: ["Large", "Deviant", "Small", "All"])
        segment.selectedSegmentIndex = 0
        
        isToolBarHidden = false;
    }
    
    override func reloadData() {
        monsterSize = selectedSize
        tableView.reloadData()
    }
}

extension Monster: DetailCellModel {
    var primary: String? { return name }
}
