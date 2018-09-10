//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class TreeCell<T, U: TreeCellView<T>>: UITableViewCell {
    let WIDTH = 5
    
    var node: Node<T>? {
        didSet {
            populateCell()
        }
    }

    let branchView = UIView()
    var branches: [Bool]?
    var branchWidthConstraint: NSLayoutConstraint?
    var treeView = U()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(branchView)
        contentView.addSubview(treeView)
        
        branchView.matchParent(top: 0, left: 0, bottom: 0, right: nil)
        treeView.matchParent(top: 0, left: nil, bottom: 0, right: 0)
        
        branchWidthConstraint = NSLayoutConstraint(item: branchView,
                                                   attribute: .width,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1.0,
                                                   constant: 0)
        addConstraint(branchWidthConstraint!)
        
        addConstraint(NSLayoutConstraint(item: branchView,
                                         attribute: .right,
                                         relatedBy: .equal,
                                         toItem: treeView,
                                         attribute: .left,
                                         multiplier: 1.0,
                                         constant: 0))
        
        branchView.clipsToBounds = false
        contentView.clipsToBounds = false
    }
    
    func populateCell() {
        self.branches = node?.getBranches()
        drawDepths()
        treeView.model = node?.object
    }
    
    private func drawDepths() {
        for view in branchView.subviews {
            view.removeFromSuperview()
        }
        
        separatorInset = UIEdgeInsets(top: 0, left: layoutMargins.left, bottom: 0, right: 0)
        
        // TODO: Write this better, maybe lines render faster with cgcontextref
        // http://stackoverflow.com/questions/3128752/draw-line-in-uiview
        
        guard let branches = branches,
            branches.count > 0 else { // Why should it be?
                branchWidthConstraint?.constant = 0
                return
        }
        
        for i in 0 ... branches.count - 1 {
            let hasBranch = branches[i]
            
            if i + 1 == branches.count {
                let line = UIView()
                line.backgroundColor = Color.Background.branch
                branchView.addSubview(line)
                
                line.frame = hasBranch
                    ? CGRect(x: (i + 1) * WIDTH, y: 0, width: 1, height: Int(frame.size.height))
                    : CGRect(x: (i + 1) * WIDTH, y: 0, width: 1, height: Int(frame.size.height / 2))
                
                let pointer = UIView()
                pointer.backgroundColor = Color.Background.branch
                branchView.addSubview(pointer)
                pointer.frame = CGRect(x: (i + 1) * WIDTH, y: Int(frame.size.height / 2), width: 3, height: 1)
            }
            
            if hasBranch {
                let line = UIView()
                line.backgroundColor = Color.Background.branch
                branchView.addSubview(line)
                
                line.matchParent(top: 0, left: Float((i + 1) * WIDTH), bottom: -1, right: nil)
                line.widthConstraint(1)
                line.clipsToBounds = false
            }
        }
        
        let branchWidth = CGFloat(WIDTH * (branches.count + 1))
        separatorInset = UIEdgeInsets(top: 0, left: layoutMargins.left + branchWidth, bottom: 0, right: 0)
        branchWidthConstraint?.constant = branchWidth
    }
}
