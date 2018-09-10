//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class DecorationList: DetailController {
    override func loadView() {
        super.loadView()
        
        title = "Decorations"
        addSimpleSection(data: Database.shared.decorations()) { DecorationDetails(id: $0.id) }
    }
}

extension Decoration: DetailCellModel {
    var primary: String? { return name }
    var subtitle: String? { return skillTreeString }
    var secondary: String? { return slotsString }
    var imageName: String? { return icon }
    
    var skillTreeString: String {
        var string = ""
        for skill in skillTrees {
            if string.count > 0 {
                 string += "\n"
            }
            string += skill.name + (skill.points > 0 ? " +" : " ") + "\(skill.points)"
        }
        return string
    }
}
