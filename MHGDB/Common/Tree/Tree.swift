//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation

class Tree<T> {
    var roots = [Node<T>]()
    
    init() {
        
    }
    
    init(objects: [T]) {
        for object in objects {
            addRoot(object)
        }
    }
    
    func addRoot(_ object: T) {
        roots.append(Node(object))
    }
    
    // Should be able to return element from index without another data structure
    var nodeArray: [Node<T>] {
        return Array(roots.map{ $0.nodeArray }.joined())
    }
    
    var array: [T] {
        return Array(roots.map{ $0.array }.joined())
    }
}
