//
// MIT License
// Copyright (c) Gathering Hall Studios
//

import UIKit

extension UIStackView {
    convenience init(axis: UILayoutConstraintAxis = .vertical, spacing: Int = 8, distribution: UIStackViewDistribution = .fill) {
        self.init()
        self.axis = axis
        self.spacing = CGFloat(spacing)
        self.distribution = .fill
    }
}
