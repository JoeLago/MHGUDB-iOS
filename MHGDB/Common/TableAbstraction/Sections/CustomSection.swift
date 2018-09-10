//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit


class CustomSection<T, U: CustomCell<T>>: DetailSection {
    var rows: [T]? {
        didSet {
            populateNumRows()
        }
    }
    
    var selectionBlock: ((T) -> Void)?
    var identifier: String = "cell" // override
    var cellClass: AnyClass
    
    init(title: String?,
         data: [T],
         header: HeaderView? = nil,
         selectionBlock: ((T) -> Void)? = nil) {
        cellClass = UITableViewCell.self
        super.init()
        self.title = title
        self.rows = data
        self.headerView = header
        self.selectionBlock = selectionBlock
        populateNumRows()
    }
    
    func populateNumRows() {
        numberOfRows = rows?.count ?? 0
    }
    
    override func initialize() {
        super.initialize()
        register(U.self)
    }
    
    override func cell(row: Int) -> UITableViewCell? {
        return dequeueCell(identifier: identifier) ?? U()
    }
    
    override func populate(cell: UITableViewCell, row: Int) {
        (cell as? U)?.model = rows?[row]
        cell.selectionStyle = selectionBlock == nil ? .none : .default
    }
    
    override func selected(row: Int, navigationController: UINavigationController?) {
        if let model = rows?[row] {
            selected(model: model)
        }
    }
    
    func selected(model: T) {
        if let selectionBlock = selectionBlock {
            selectionBlock(model)
        }
    }
}
