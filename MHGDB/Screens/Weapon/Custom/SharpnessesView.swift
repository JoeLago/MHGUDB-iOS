//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class SharpnesesView: UIView {
    var sharpnessViews = [SharpnessView]()
    
    var sharpnesses: [Sharpness]? {
        didSet {
            if sharpnesses == nil {
                isHidden = true
                return
            }
            
            isHidden = false
            sharpnessViews[0].sharpness = sharpnesses![0]
            sharpnessViews[1].sharpness = sharpnesses![1]
            sharpnessViews[2].sharpness = sharpnesses![2]
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        createViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createViews() {
        sharpnessViews.append(SharpnessView())
        sharpnessViews.append(SharpnessView())
        sharpnessViews.append(SharpnessView())
        
        addSubview(sharpnessViews[0])
        addSubview(sharpnessViews[1])
        addSubview(sharpnessViews[2])
        
        sharpnessViews[0].paddingBottom = 1
        sharpnessViews[1].paddingTop = 1
        sharpnessViews[1].paddingBottom = 1
        sharpnessViews[2].paddingTop = 1
        
        useConstraintsOnly()
        
        addConstraints(
            formatStrings: ["H:|[one]|",
                            "H:|[two]|",
                            "H:|[three]|",
                            "V:|[one(==two)][two(==one)][three(==one)]|"],
            views: [
                "one": sharpnessViews[0],
                "two": sharpnessViews[1],
                "three": sharpnessViews[2]
            ],
            metrics: [:])
    }
}
