//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

struct CombinationCellModel {
    var combination: Combination
    var itemSelected: ((Int) -> Void)
}

class CombinationCell: CustomCell<CombinationCellModel> {
    let resultView = IconImage()
    let item1View = IconImage()
    let item2View = IconImage()
    
    override var model: CombinationCellModel? {
        didSet {
            if let model = model {
                populate(combo: model)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let stack = UIStackView(axis: .horizontal, spacing: 5, distribution: .fillEqually)
        let resultWrapper = UIView()
        let requiredItems = UIStackView(axis: .vertical, spacing: 5, distribution: .fill)
        
        contentView.addSubview(stack)
        resultWrapper.addSubview(resultView)
        stack.addArrangedSubview(resultWrapper)
        stack.addArrangedSubview(requiredItems)
        requiredItems.addArrangedSubview(item1View)
        requiredItems.addArrangedSubview(item2View)
        
        resultView.centerYAnchor.constraint(equalTo: resultWrapper.centerYAnchor).isActive = true
        resultView.matchParent(top: nil, left: 0, bottom: nil, right: 0)
        resultView.matchParent(top: 0, left: nil, bottom: 0, right: nil, relatedBy: .greaterThanOrEqual)
        resultWrapper.widthAnchor.constraint(equalTo: requiredItems.widthAnchor).isActive = true
        stack.matchParent(top: 5, left: 15, bottom: 5, right: 15)
    }
    
    func populate(combo: CombinationCellModel) {
        resultView.set(id: combo.combination.createdId,
                       iconImage: combo.combination.createdIcon,
                       name: combo.combination.createdName,
                       selected: combo.itemSelected)
        
        item1View.set(id: combo.combination.firstId,
                      iconImage: combo.combination.firstIcon,
                      name: combo.combination.firstName,
                      selected: combo.itemSelected)
        
        item2View.set(id: combo.combination.secondId,
                      iconImage: combo.combination.secondIcon,
                      name: combo.combination.secondName,
                      selected: combo.itemSelected)
    }
}

class IconImage: UIStackView {
    var id: Int?
    let label = UILabel()
    let icon = UIImageView()
    var selected: ((Int) -> Void)?
    
    init() {
        super.init(frame: .zero)
        axis = .horizontal
        spacing = 5
        label.textColor = Color.Text.primary
        label.font = Font.title
        
        let iconWrapper = UIView()
        iconWrapper.addSubview(icon)
        addArrangedSubview(iconWrapper)
        addArrangedSubview(label)
        
        icon.centerYAnchor.constraint(equalTo: iconWrapper.centerYAnchor).isActive = true
        icon.matchParent(top: nil, left: 0, bottom: nil, right: 0)
        icon.matchParent(top: 0, left: nil, bottom: 0, right: nil, relatedBy: .greaterThanOrEqual)
        icon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        addGestureRecognizer(tapGesture)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(id: Int?, iconImage: String?, name: String, selected: ((Int) -> Void)? = nil) {
        self.id = id
        icon.image = UIImage(named: iconImage ?? "")
        label.text = name
        self.selected = selected
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if let id = id {
            selected?(id)
        }
    }
}

