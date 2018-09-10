//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class LocationList: DetailController {
    override func loadView() {
        super.loadView()
        title = "Locations"
        addSimpleSection(data: Database.shared.locations()) { LocationDetails(location: $0) }
    }
}

extension Location: DetailCellModel {
    var primary: String? { return name }
    var imageName: String? { return icon }
}
