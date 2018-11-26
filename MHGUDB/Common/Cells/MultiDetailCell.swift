//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class MultiDetailCell: UITableViewCell {
    let stack = UIStackView(axis: .horizontal, spacing: 18)
    
    init(details: [SingleDetailView]) {
        super.init(style: .value2, reuseIdentifier: String(describing: SingleDetailCell.self))
        selectionStyle = .none
        initializeViews()
        for detail in details {
            addView(detail)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addDetail(_ detail: SingleDetailLabel) {
        addView(detail)
    }
    
    func addView(_ view: UIView) {
        stack.addArrangedSubview(view)
    }
    
    func initializeViews() {
        contentView.addSubview(stack)
        stack.matchParent(top: 4, left: 25, bottom: 4, right: nil)
    }
}

class SingleDetail {
    var label: String?
    var text: String?
    var attributedText: NSAttributedString?
    
    init(label: String?, value: NSAttributedString?) {
        self.label = label
        self.attributedText = value
    }
    
    init(label: String?, value: String?) {
        self.label = label
        self.text = value
    }
    
    init(label: String?, value: Int?) {
        self.label = label
        if let value = value {
            self.text = "\(value)"
        }
    }
}

class SingleDetailView: UIStackView {
    let labelView = UILabel()
    let label: String
    let detailView: UIView
    
    init(label: String, detailView: UIView) {
        self.label = label
        self.detailView = detailView
        super.init(frame: .zero)
        axis = .vertical
        spacing = 3
        initializeViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeViews() {
        labelView.text = label
        labelView.font = Font.subTitle
        labelView.textColor = Color.Text.primary
        labelView.numberOfLines = 0
        addArrangedSubview(labelView)
        addArrangedSubview(detailView)
    }
}

class SingleDetailLabel: SingleDetailView {
    let detail = UILabel()
    
    var detailModel: SingleDetail? {
        didSet {
            populate()
        }
    }
    
    convenience init(label: String, value: String?) {
        self.init(SingleDetail(label: label, value: value))
    }
    
    convenience init(label: String, value: Int?) {
        self.init(SingleDetail(label: label, value: value))
    }
    
    convenience init(label: String, attributedString: NSAttributedString?) {
        self.init(SingleDetail(label: label, value: attributedString))
    }
    
    init(_ model: SingleDetail) {
        super.init(label: "", detailView: detail)
        initializeViews()
        self.detailModel = model
        populate()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initializeViews() {
        super.initializeViews()
        detail.numberOfLines = 0
        detail.font = Font.title
    }
    
    private func populate() {
        if detailModel?.text?.count ?? 0 > 50 {
            detail.font = Font.title
        }
        
        labelView.text = detailModel?.label
        
        if let text = detailModel?.attributedText {
            detail.attributedText = text
        } else {
            detail.text = detailModel?.text
        }
    }
}
