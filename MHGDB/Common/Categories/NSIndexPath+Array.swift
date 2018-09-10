//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation

extension NSIndexPath {
    class func indexPathsFor(section: Int, startRow: Int, count: Int) -> [IndexPath] {
        return indexPathsFor(section: section, startRow: startRow, endRow: startRow + count)
    }
    
    class func indexPathsFor(section: Int, startRow: Int, endRow: Int) -> [IndexPath] {
        return [Int](startRow ... endRow).map { return IndexPath(item: $0, section: section)  }
    }
}
