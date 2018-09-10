//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class PalicoList: DetailController {
    override func loadView() {
        super.loadView()
        title = "Palico Weapons"
        addCustomSection(data: Database.shared.palicoWeapons(), cellType: PalicoWeaponCell.self) { PalicoWeaponDetails(id: $0.id) }
    }
}

extension PalicoWeapon: DetailCellModel {
    var primary: String? { return name }
    var subtitle: String? { return nil }
    var secondary: String? { return nil }
    var imageName: String? { return icon }
}
