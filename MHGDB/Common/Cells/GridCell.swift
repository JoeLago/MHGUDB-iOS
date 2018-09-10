//
// MIT License
// Copyright (c) Gathering Hall Studios
//


// TODO: This shouldn't have to inherit from CustomCell, fix when CustomCell is made a protocol

import UIKit


class GridCell<T>: CustomCell<T> {
    let colStack = UIStackView(axis: .horizontal, spacing: 0)
    var columns = [LabelStack]()
    
    init() {
        super.init(style: .default, reuseIdentifier: "idontcare")
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        contentView.addSubview(colStack)
        colStack.matchParent(top: 5, left: nil, bottom: 5, right: nil)
        
        NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal,
                           toItem: colStack, attribute: .centerX,
                           multiplier: 1, constant: 0).isActive = true
    }
    
    func add(imageNames: [String]) {
        let attributeStrings = imageNames.map { $0.attributedImage }
        add(values: attributeStrings)
    }
    
    func add(values: [Any]) {
        if columns.count == 0 {
            for _ in 0 ... values.count - 1 {
                let column = LabelStack(axis: .vertical)
                column.showSeparator = true
                colStack.addArrangedSubview(column)
                columns.append(column)
            }
        }
        
        for i in 0 ... columns.count - 1 {
            let columnStack = columns[i]
            let value = values[i]
            
            columnStack.add(value: value)
        }
    }
}
