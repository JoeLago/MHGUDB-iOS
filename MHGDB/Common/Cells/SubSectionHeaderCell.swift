//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class SubSectionHeaderCell: UITableViewCell {
    private let label = UILabel()
    
    var labelText: String? {
        didSet {
            label.text = labelText
        }
    }
    
    init() {
        super.init(style: .value2, reuseIdentifier: String(describing: SingleDetailCell.self))
        selectionStyle = .none
        initializeViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeViews() {
        contentView.addSubview(label)
        contentView.useConstraintsOnly()
        label.matchParent(top: 15, left: 15, bottom: 8, right: 15)
        
        label.font = Font.titleMedium
        label.textColor = Color.Text.subHeader
        label.numberOfLines = 0
        
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10000)
    }
}
