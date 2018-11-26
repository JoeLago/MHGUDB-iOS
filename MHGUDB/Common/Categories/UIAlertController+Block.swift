//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

extension UIAlertController {
    convenience init(options: [String], selectionBlock: @escaping (Int, String) -> Void) {
        self.init()
        
        for (index, option) in options.enumerated() {
            addAction(UIAlertAction(title: option, style: .default, handler: { (UIAlertAction) in
                selectionBlock(index, option)
            }))
        }
        
        addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
}
