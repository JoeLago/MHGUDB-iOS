//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class ItemList: DetailController {
    override func loadView() {
        super.loadView()
        title = "Items"
        addSimpleSection(data: Database.shared.items()) { ItemDetails(item: $0) }
    }
}

extension Item: DetailCellModel {
    var primary: String? { return name }
    var imageName: String? { return icon }
    var tintColor: UIColor? { return iconColor }
}
