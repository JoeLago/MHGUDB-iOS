//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

struct SubsectionRow {
    var section: DetailSection
    var row: Int
    var isHeader: Bool { return row == -1 }
}

class SubSection: DetailSection {
    private var subSections = [DetailSection]()
    
    init(subSections: [DetailSection], title: String) {
        self.subSections = subSections
        super.init()
        self.title = title
    }
    
    func totalRows(subSection: DetailSection) -> Int {
        return (subSection.hasHeader ? 1 : 0) + subSection.numberOfRows
    }
    
    override func initialize() {
        var numberOfRows = 0
        for subSection in subSections {
            numberOfRows += totalRows(subSection: subSection)
        }
        self.numberOfRows = numberOfRows
    }
    
    func subSectionRow(row: Int) -> SubsectionRow {
        var sectionIndex = 0
        var currRow = 0
        
        while currRow <= numberOfRows {
            let subSection = subSections[sectionIndex]
            
            if row < currRow + totalRows(subSection: subSection) {
                return SubsectionRow(section:subSections[sectionIndex],
                                     row: row - currRow - (subSection.hasHeader ? 1 : 0))
            }
            
            sectionIndex += 1
            currRow += totalRows(subSection: subSection)
        }
        
        Log(error: "Missing subsection row")
        return SubsectionRow(section:subSections[0], row: 0)
    }
    
    override func longPress(row: Int) {
        let sub = subSectionRow(row: row)
        sub.section.longPress(row: sub.row)
    }
    
    override func cell(row: Int) -> UITableViewCell? {
        let sub = subSectionRow(row: row)
        
        if sub.row == -1 {
            return SubSectionHeaderCell()
        }
        
        return sub.section.cell(row: row)
    }
    
    override func register(_ cellClass: AnyClass, identifier: String? = nil) {
        tableView?.register(cellClass, forCellReuseIdentifier: identifier ?? String(describing: cellClass))
    }
    
   override func dequeueCell(identifier: String) -> UITableViewCell? {
        return tableView?.dequeueReusableCell(withIdentifier: identifier)
    }
    
    override func populate(cell: UITableViewCell, row: Int) {
        let sub = subSectionRow(row: row)
        
        if sub.row == -1 {
            (cell as? SubSectionHeaderCell)?.labelText = sub.section.title
        } else {
            sub.section.populate(cell: cell, row: sub.row)
        }
    }
    
    override func selected(row: Int, navigationController: UINavigationController?) {
        let sub = subSectionRow(row: row)
        
        guard !sub.isHeader else {
            return
        }
        
        sub.section.selected(row: sub.row, navigationController: navigationController)
    }
}
