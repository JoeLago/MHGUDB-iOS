//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class SharpnessView: UIView {
    var sharpness: Sharpness? {
        didSet {
            var count = 0
            if let sharpness = sharpness {
                if sharpness.red > 0 { count += 1 }
                if sharpness.orange > 0 { count += 1 }
                if sharpness.yellow > 0 { count += 1 }
                if sharpness.green > 0 { count += 1 }
                if sharpness.blue > 0 { count += 1 }
                if sharpness.white > 0 { count += 1 }
                if sharpness.purple > 0 { count += 1 }
            }
            
            if count == 1 {
                oneValue = true
            }
            
            setNeedsDisplay()
        }
    }
    var sharpnessHeight = 0
    
    var paddingTop = 2
    var paddingBottom = 2
    var y = 0
    var height = 0
    var ratio = 0.0
    var start = 0
    var end = 0 // width?
    var oneValue = false
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if sharpness == nil {
            Color.Background.light.setFill()
            UIRectFill(frame)
            return
        }
        
        y = paddingTop
        start = 0
        end = 2
        height = Int(rect.size.height) - paddingTop - paddingBottom
        let width = Double(rect.size.width) - Double(end) * 2.0
        ratio = oneValue ? width : width / Sharpness.max
        Color.Background.dark.setFill()
        UIRectFill(rect)
        
        addColor(color: Color.Sharpness.red, amount: sharpness?.red )
        addColor(color: Color.Sharpness.orange, amount: sharpness?.orange)
        addColor(color: Color.Sharpness.yellow, amount: sharpness?.yellow)
        addColor(color: Color.Sharpness.green, amount: sharpness?.green)
        addColor(color: Color.Sharpness.blue, amount: sharpness?.blue)
        addColor(color: Color.Sharpness.white, amount: sharpness?.white)
        addColor(color: Color.Sharpness.purple, amount: sharpness?.purple)
    }
    
    func addColor(color: UIColor, amount: Int?) {
        start += end
        end = Int(Double(amount ?? 0) * ratio)
        color.setFill()
        UIRectFill(CGRect(x: start, y: y, width: end, height: height))
    }
}
