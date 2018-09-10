//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class MultiCellSection: DetailSection {
    private var cells = [UITableViewCell]()
    
    override init() {
        super.init()
        populateCells()
        numberOfRows = cells.count
        showCountMinRows = -1
    }
    
    func addCell(_ cell: UITableViewCell) {
        cells.append(cell)
        cell.selectionStyle = .none
    }
    
    func addDetail(label: String?, text: String?) {
        guard let text = text else {
            return
        }
        addCell(SingleDetailCell(label: label, text: text))
    }
    
    func addDetail(label: String?, value: Int?) {
        addDetail(label: label, text: value == nil ? nil : "\(value ?? 0)")
    }
    
    func populateCells() {
    }
    
    override func cell(row: Int) -> UITableViewCell? {
        return cells[row]
    }
}
