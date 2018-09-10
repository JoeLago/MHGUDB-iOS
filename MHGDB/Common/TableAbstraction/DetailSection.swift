//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class DetailSection { // TODO: TableSection Refactor
    var tableView: UITableView?
    var index: Int?
    var isCollapsed = false
    var headerView: HeaderView?
    var cleanTitle: String?
    var showCountMinRows = 2
    
    var defaultCollapseCount = -1 {
        didSet {
            updateCollapsed()
        }
    }
    
    var numberOfRows = 0 {
        didSet {
            updateCollapsed()
        }
    }
    
    var title: String? {
        set {
            cleanTitle = newValue
        }
        get {
            guard let cleanTitle = cleanTitle else { return nil }
            return cleanTitle + (showCountMinRows >= 0 && numberOfRows >= showCountMinRows
                ? (" (\(numberOfRows))") : "")
        }
    }
    
    var hasHeader: Bool {
        return (headerView != nil || title != nil) && numberOfRows != 0
    }
    
    func initialize() {
        
    }
    
    func updateCollapsed() {
        if defaultCollapseCount >= 0 {
            if isCollapsed == false && numberOfRows >= defaultCollapseCount && title != nil {
                isCollapsed = true
            }
        }
    }
    
    func longPress(row: Int) {
        
    }
    
    func cell(row: Int) -> UITableViewCell? {
        return UITableViewCell()
    }
    
    func register(_ cellClass: AnyClass, identifier: String? = nil) {
        tableView?.register(cellClass, forCellReuseIdentifier: identifier ?? String(describing: cellClass))
    }
    
    func dequeueCell(identifier: String) -> UITableViewCell? {
        return tableView?.dequeueReusableCell(withIdentifier: identifier)
    }
    
    func populate(cell: UITableViewCell, row: Int) {
        
    }
    
    func selected(row: Int, navigationController: UINavigationController?) {
        
    }
}
