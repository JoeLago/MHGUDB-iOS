//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

protocol StyledText {
    var text: String { get }
    var isBold: Bool { get }
}

class LabelStack: UIStackView {
    var length: Int?
    var textAlignment: NSTextAlignment?
    var fontSize: CGFloat = 12
    var count = 0
    var showSeparator = false
    
    init(axis: UILayoutConstraintAxis, length: Int? = nil) {
        super.init(frame: .zero)
        self.axis = axis
        self.spacing = 0
        self.length = length
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func newLabel() -> UILabel {
        let label = MarginLabel()
        label.textAlignment = textAlignment ?? .right
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = Color.Text.primary
        let verticalPadding: CGFloat = showSeparator ? 2 : 0
        label.edgeInsets = UIEdgeInsets(top: verticalPadding, left: 5, bottom: verticalPadding, right: 5)
        
        if let length = length {
            if axis == .horizontal {
                label.widthConstraint(length)
            } else {
                label.heightConstraint(length)
            }
        }
        
        return label
    }
    
    func addTopSeparator(view: UIView) {
        let separator = UIView()
        separator.backgroundColor = Color.Background.seperator
        view.addSubview(separator)
        separator.matchParent(top: 0, left: 0, bottom: nil, right: 0)
        separator.heightConstraint(1)
    }
    
    func add(values: [Any]) {
        for value in values {
            add(value: value)
        }
    }
    
    func add(value: Any) {
        let label = newLabel()
        if showSeparator, count > 0 {
            addTopSeparator(view: label)
        }
        
        if let value = value as? StyledText {
            if value.isBold {
                let font = label.font
                label.font = UIFont.boldSystemFont(ofSize: font?.pointSize ?? fontSize)
            }
            
            label.text = value.text
        } else if let value = value as? Int {
            label.text = value == 0 ? "-" : "\(value)" // TODO: have a var to determine this behavior
        } else if let value = value as? String {
            label.text = value
        } else if let value = value as? NSAttributedString {
            label.attributedText = value
        } else {
            label.text = " "
        }
        
        addArrangedSubview(label)
        count += 1
    }
}

/**
 This class can be used when you want to add inset/margin inside a text label
 to avoid deepening the view hierarchy with encapsulating views that just add margins/padding
 */
class MarginLabel: UILabel {
    var edgeInsets = UIEdgeInsets.zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, self.edgeInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let newWidth = size.width + edgeInsets.left + edgeInsets.right
        let newHeight = size.height + edgeInsets.top + edgeInsets.bottom
        return CGSize(width: newWidth, height: newHeight)
    }
}
