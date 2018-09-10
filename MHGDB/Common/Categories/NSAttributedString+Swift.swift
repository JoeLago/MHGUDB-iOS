//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

extension NSMutableAttributedString {
    func append(string: String) {
        append(NSAttributedString(string: string))
    }
    
    func append(int: Int) {
        append(NSAttributedString(string: "\(int)"))
    }
    
    func append(image: UIImage?) {
        let attachment = NSTextAttachment()
        attachment.image = image
        append(NSAttributedString(attachment: attachment))
    }
    
    func append(image: UIImage?, rect: CGRect) {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = rect
        append(NSAttributedString(attachment: attachment))
    }
    
    // TODO: Potentially want to pass in frame here
    func appendImage(named: String) {
        let image = UIImage(named: named)
        if (image == nil) {
            Log(error: "Attributed string image not found: '\(named)'")
        }
        append(image: image, rect: CGRect(x: 2, y: -3, width: 15, height: 15))
    }
}

extension NSMutableAttributedString {
    convenience init(damage: Int, element: Element?, elementDamage: Int?, affinity: Int? = nil) {
        self.init()
        append(string: "\(damage)")
        if let elementDamage = elementDamage, elementDamage > 0 {
            appendImage(named: (element?.rawValue ?? "") + ".png")
            append(string: " \(elementDamage)")
        }
        if let affinity = affinity, affinity != 0 {
            append(string: " \(affinity > 0 ? "+" : "")\(affinity)%")
        }
    }
}
