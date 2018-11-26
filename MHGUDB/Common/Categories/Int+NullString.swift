//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation

extension Int {
    init?(_ string: String?) {
        if string == nil {
            return nil
        }
        self.init(string!)
    }
}
