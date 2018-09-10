//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class TreeSection<T, U: TreeCellView<T>>: DetailSection {
    let tree: Tree<T>
    var selectedNode: Node<T>?
    var nodeArray: [Node<T>]
    var collapsedNodes = [Node<T>]()
    var selectionBlock: ((T) -> Void)?
    
    init(tree: Tree<T>, selectionBlock: ((T) -> Void)? = nil) {
        self.tree = tree
        self.nodeArray = tree.nodeArray
        self.selectionBlock = selectionBlock
        super.init()
        
        self.numberOfRows = self.nodeArray.count
    }
    
    override func initialize() {
        super.initialize()
        register(TreeCell<T, U>.self, identifier: "TREECELL")
    }
    
    override func cell(row: Int) -> UITableViewCell? {
        return dequeueCell(identifier: "TREECELL") ?? TreeCell<T, U>()
    }
    
    override func populate(cell: UITableViewCell, row: Int) {
        if let cell = cell as? TreeCell<T, U> {
            cell.node = nodeArray[row]
            cell.treeView.isSelected = cell.node === selectedNode
        }
    
        cell.selectionStyle = selectionBlock == nil ? .none : .default
    }
    
    override func selected(row: Int, navigationController: UINavigationController?) {
        selected(model: nodeArray[row].object)
    }
    
    func selected(model: T) {
        if let selectionBlock = selectionBlock {
            selectionBlock(model)
        }
    }
    
    override func longPress(row: Int) {
        //collapse(row: row)
    }
}


// MARK: Collapse/Expand
// Maybe this would look better if we kept the collapsed state in the node?

extension TreeSection {
    
    func indexPathsFor(section: Int, startRow: Int, count: Int) -> [IndexPath] {
        return indexPathsFor(section: section, startRow: startRow, endRow: startRow + count)
    }
    
    func indexPathsFor(section: Int, startRow: Int, endRow: Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for i in startRow ... endRow {
            indexPaths.append(IndexPath(item: i, section: section))
        }
        return indexPaths
    }
    
    func collapse(row: Int) {
        let node = nodeArray[row]
        
        if collapsedNodes.contains(node) {
            return
        }
        
        let children = node.childArray
        if children.count < 1 {
            return
        }
        
        let oldCount = numberOfRows
        collapsedNodes.append(node)
        nodeArray.remove(objects: children)
        numberOfRows = nodeArray.count
        
        let difference = oldCount - numberOfRows
        if difference > 0 {
            let indexPaths = indexPathsFor(section: 0, startRow: row + 1, count: difference - 1)
            tableView?.beginUpdates()
            tableView?.reloadRows(at: [IndexPath(item: row, section: 0)], with: .automatic)
            tableView?.deleteRows(at: indexPaths, with: .automatic)
            tableView?.endUpdates()
        }
    }
    
    func expand(row: Int) {
        let node = nodeArray[row]

        // TODO: account for already collapsed
        var children = node.childArray
        collapsedNodes.remove(object: node)
        for childNode in children {
            if collapsedNodes.contains(childNode) {
                children.remove(object: childNode)
            }
        }
        
        nodeArray.insert(contentsOf: children, at: row + 1)
        let indexPaths = indexPathsFor(section: 0, startRow: row + 1, count: children.count - 1)
        
        tableView?.beginUpdates()
        tableView?.reloadRows(at: [IndexPath(item: row, section: 0)], with: .automatic)
        tableView?.insertRows(at: indexPaths, with: .automatic)
        tableView?.endUpdates()
    }
}
