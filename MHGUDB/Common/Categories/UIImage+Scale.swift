//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

extension UIImage {
    func scale(_toSize: CGSize) -> UIImage? {
        //UIGraphicsBeginImageContext(newSize);
        // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
        // Pass 1.0 to force exact pixel size.
        UIGraphicsBeginImageContextWithOptions(_toSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: _toSize.width, height: _toSize.height))
        let sizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return sizedImage
    }
}
