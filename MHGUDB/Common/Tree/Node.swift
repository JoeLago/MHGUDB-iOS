//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation


class Node<T> {
    var object: T
    var parent: Node? = nil
    var children = [Node<T>]()
    
    init(_ object: T, parent: Node? = nil) {
        self.object = object
        self.parent = parent
    }
    
    var depth: Int {
        return parent?.depth ?? 1
    }
    
    func getBranches(childNode: Node<T>? = nil) -> [Bool] {
        var branches = (parent != nil) ? parent!.getBranches(childNode: self) : [Bool]()
        
        
        if let childNode = childNode {
            let index = children.index(where: { (node: Node<T>) -> Bool in
                node === childNode
            })
            
            // bleh
            let isBranch = children.count > 1 && (index ?? children.count)  < children.count - 1
            branches.append(isBranch)
        }
        
        return branches
    }
    
    func addChildren(_ objects: [T]) {
        for object in objects {
            addChild(object)
        }
    }
    
    func addChild(_ object: T) {
        children.append(Node(object, parent: self))
    }
    
    var nodeArray: [Node<T>] {
        return [self] + childArray
    }
    
    var childArray: [Node<T>] {
        return Array(children.map{ $0.nodeArray }.joined())
    }
    
    var array: [T] {
        return [object] + Array(children.map{ $0.array }.joined())
    }
}

extension Node: Equatable {
    static func == (lhv: Node<T>, rhv: Node<T>) -> Bool {
        return lhv === rhv
    }
}
