//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class HeaderView: UIView {
    var section: Int?
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    var isCollapsed = false {
        didSet {
            updateIndicator()
        }
    }
    
    
    private var label = UILabel()
    private var indicator = UILabel()
    private var seperator = UIView()
    
    init() {
        super.init(frame: CGRect.zero)
        setupViews()
        updateIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = Color.Background.header
        label.font = Font.header
        indicator.textAlignment = .right
        indicator.font = Font.header
        seperator.backgroundColor = Color.Background.seperator
        
        addSubview(label)
        addSubview(indicator)
        addSubview(seperator)
        
        label.matchParent(top: 8, left: 15, bottom: 5, right: 15, priority: UILayoutPriority.defaultHigh)
        indicator.matchParent(top: 8, left: nil, bottom: 5, right: 15, priority: UILayoutPriority.defaultHigh)
        seperator.matchParent(top: nil, left: 0, bottom: 0, right: 0, priority: UILayoutPriority.defaultHigh)
        seperator.heightConstraint(1)
    }
    
    func updateIndicator() {
        indicator.text = isCollapsed ? "+" : "-"
    }
}
