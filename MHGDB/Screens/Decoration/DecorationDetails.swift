//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class DecorationDetails: DetailController, DetailScreen {
    var id: Int
    
    convenience init(id: Int) {
        self.init(Database.shared.decoration(id: id))
    }
    
    init(_ decoration: Decoration) {
        id = decoration.id
        super.init()
        title = decoration.name
        addSimpleSection(data: [decoration])
        add(section: DecorationDetailSection(decoration: decoration))
        addSimpleSection(data: decoration.skillTrees, title: "Skills") { SkillDetails(id: $0.skillId) }
        addSimpleSection(data: decoration.components, title: "Components") { ItemDetails(id: $0.componentId) }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DecorationSkillTree: DetailCellModel {
    var primary: String? { return name }
    var secondary: String? { return "\(points > 0 ? "+" : "")\(points)" }
}

extension DecorationComponent: DetailCellModel {
    var primary: String? { return name }
    var imageName: String? { return icon }
    var secondary: String? { return "x \(quantity)" }
}
