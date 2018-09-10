//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class ItemDetailSection: MultiCellSection {
    var item: Item
    
    init(item: Item) {
        self.item = item
        super.init()
        title = "Details"
    }
    
    override func populateCells() {
        addCell(MultiDetailCell(details: [
            SingleDetailLabel(label: "Stack", value: item.stack),
            SingleDetailLabel(label: "Buy", value: item.buy),
            SingleDetailLabel(label: "Sell", value: item.sell)
            ]))
        
        addDetail(label: "Description", text: item.description)
    }
}
