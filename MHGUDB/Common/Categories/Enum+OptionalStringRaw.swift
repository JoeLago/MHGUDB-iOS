//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation

extension RawRepresentable where RawValue == String {
    init?(optionalRaw: String?) {
        guard let optionalRaw = optionalRaw else {
            return nil
        }
      
        self.init(rawValue: optionalRaw)
    }
}
