//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

extension UIView {
    
    @discardableResult
    func addMatchingConstraint(item: UIView, toItem: UIView?, attribute: NSLayoutAttribute,
                               offset: Float = 0, priority: UILayoutPriority = UILayoutPriority.required,
                               relatedBy: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: item, attribute: attribute, relatedBy: relatedBy,
            toItem: toItem, attribute: attribute, multiplier: 1, constant: CGFloat(offset))
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    func matchParent(top: Float? = 0, left: Float? = 0, bottom: Float? = 0, right: Float? = 0,
                     priority: UILayoutPriority = UILayoutPriority.required, relatedBy: NSLayoutRelation = .equal) {
        guard let superView = superview else {
            Log(error: "matchParent: No parent view")
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            addMatchingConstraint(item: self, toItem: superView, attribute: .top,
                                  offset: top, priority: priority, relatedBy: relatedBy)
        }
        
        if let left = left {
            addMatchingConstraint(item: self, toItem: superView, attribute: .left,
                                  offset: left, priority: priority, relatedBy: relatedBy)
        }
        
        if let right = right {
            addMatchingConstraint(item: superView, toItem: self, attribute: .right,
                                  offset: right, priority: priority, relatedBy: relatedBy)
        }
        
        if let bottom = bottom {
            addMatchingConstraint(item: superView, toItem: self, attribute: .bottom,
                                  offset: bottom, priority: priority, relatedBy: relatedBy)
        }
    }
    
    func matchWidth(view: UIView) {
        NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal,
                           toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive = true
    }
    
    func centerVertical() {
        guard let superView = superview else {
            print("centerVertical: No parent view")
            return
        }
        addMatchingConstraint(item: self, toItem: superView, attribute: .centerY)
    }
    
    func useConstraintsOnly() {
        for view in subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.useConstraintsOnly()
        }
    }
    
    func removeSubViews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    func removeConstraints() {
        for constraint in constraints {
            removeConstraint(constraint)
        }
    }
    
    func addConstraints(formatStrings: [String], views: [String: AnyObject], metrics: [String: CGFloat]?) {
        var constraints = [NSLayoutConstraint]()
        for formatString in formatStrings {
            constraints +=
                NSLayoutConstraint.constraints(withVisualFormat: formatString, options: [], metrics: metrics ?? [:], views: views)
        }
        self.addConstraints(constraints)
    }
    
    func makeConstraints(format: String, options opts: NSLayoutFormatOptions = [],
                         metrics: [String : AnyObject]? = [:], views: [String : AnyObject]) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: format, options: opts, metrics: metrics, views: views)
    }
    
    @discardableResult
    func widthConstraint(_ equalTo: Int) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(equalTo))
        addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func heightConstraint(_ height: Int) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(height))
        addConstraint(constraint)
        return constraint
    }
    
    func matchHorizontal(padding: Float = 0) {
        if let superView = self.superview {
            _ = superView.addMatchingConstraint(item: self, toItem: superView, attribute: .left, offset: padding)
            _ = superView.addMatchingConstraint(item: self, toItem: superView, attribute: .right, offset: -padding)
        }
    }
}
