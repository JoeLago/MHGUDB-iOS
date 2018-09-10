//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class MonsterList: DetailController {
    var monsterSection: SimpleDetailSection<Monster>!
    var segment: UISegmentedControl!
    
    override func loadView() {
        super.loadView()
        
        title = "Monsters"
        
        monsterSection = SimpleDetailSection(data: Database.shared.monsters(size: .large)) {
            [unowned self] (model: Monster) in
            self.push(MonsterDetails(id: model.id))
        }
        add(section: monsterSection)
        
        segment = populateToolbarSegment(items: ["Large", "Small", "All"])
        segment.selectedSegmentIndex = 0
        
        isToolBarHidden = false;
    }
    
    var selectedSize: Monster.Size? {
        get {
            switch segment.selectedSegmentIndex {
            case 0: return .large
            case 1: return .small
            default: return nil
            }
        }
    }
    
    var monsterSize: Monster.Size? {
        didSet {
            monsterSection.rows = Database.shared.monsters(size: monsterSize)
        }
    }
    
    override func reloadData() {
        monsterSize = selectedSize
        tableView.reloadData()
    }
}

extension Monster: DetailCellModel {
    var primary: String? { return name }
    var imageName: String? { return icon }
}
