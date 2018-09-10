//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class SkillList: DetailController {
    override func loadView() {
        super.loadView()
        title = "Skill Trees"
        addSimpleSection(data: Database.shared.skillTrees()) { SkillDetails(id: $0.id) }
    }
}

extension SkillTree: DetailCellModel {
    var primary: String? { return name }
}
