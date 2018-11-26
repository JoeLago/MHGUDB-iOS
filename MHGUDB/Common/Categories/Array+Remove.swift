//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation

extension Array where Element: Equatable {
    mutating func remove(object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    
    mutating func remove(objects: [Element]) {
        for object in objects {
            self.remove(object: object)
        }
    }
}
