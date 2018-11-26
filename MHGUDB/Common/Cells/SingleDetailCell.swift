//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class SingleDetailCellModel {
    var label: String?
    var text: String?
    
    init(label: String?, text: String?) {
        self.label = label
        self.text = text
    }
}

class SingleDetailCell: UITableViewCell {
    let label = UILabel()
    let detail = UILabel()
    
    var detailModel: SingleDetailCellModel? {
        didSet {
            populateCell()
        }
    }
    
    init() {
        super.init(style: .value2, reuseIdentifier: String(describing: SingleDetailCell.self))
        selectionStyle = .none
        initializeViews()
    }
    
    convenience init(label: String?, text: String?) {
        self.init()
        self.detailModel = SingleDetailCellModel(label: label, text: text)
        populateCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeViews() {
        let stack = UIStackView(axis: .vertical, spacing: 0)
        contentView.addSubview(stack)
        contentView.useConstraintsOnly()
        stack.matchParent(top: 4, left: 25, bottom: 4, right: 25)
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(detail)
        
        label.font = Font.subTitle
        label.textColor = Color.Text.primary
        label.numberOfLines = 0
        detail.numberOfLines = 0
        detail.font = Font.title
    }
    
    private func populateCell() {
        if detailModel?.text?.count ?? 0 > 50 {
            detail.font = Font.title
        }
        
        label.text = detailModel?.label
        detail.text = detailModel?.text
    }
}
