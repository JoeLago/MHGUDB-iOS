//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class LocationDetails: DetailController, DetailScreen {
    var id: Int
    
    convenience required init(id: Int) {
        self.init(location: Database.shared.location(id: id))
    }
    
    init(location: Location) {
        id = location.id
        super.init()
        title = location.name
        addCustomSection(data: [location], cellType: MapCell.self)
        addSimpleSection(data: location.monsters, title: "Monsters") { MonsterDetails(id: $0.monsterId) }
        addItemSection(location: location, rank: .low, title: "Low Rank Items")
        addItemSection(location: location, rank: .high, title: "High Rank Items")
        addItemSection(location: location, rank: .g, title: "G Rank Items")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("I don't want to use storyboards Apple")
    }
    
    func addItemSection(location: Location, rank: Quest.Rank, title: String) {
        let items = location.itemsByNode(rank: rank)
        let sections = [SimpleDetailSection](items.keys.sorted().map
        { SimpleDetailSection(data: items[$0]!, title: $0, showCountMinRows: -1)
        { self.push(ItemDetails(id: $0.itemId)) } })
        add(section: SubSection(subSections: sections, title: title))
    }
}

extension LocationMonster: DetailCellModel {
    var primary: String? { return monster }
    var subtitle: String? { return areas }
    var imageName: String? { return icon }
}

extension LocationItem: DetailCellModel {
    var primary: String? { return (name ?? "") + (stack ?? 0 > 1 ? " x\(stack ?? 0)": "") }
    var imageName: String? { return icon }
    var secondary: String? { return "\(Int(chance ?? 0))%" }
}
