//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

struct Color {
    struct Text {
        static let primary = UIColor(hex: 0x292E37)
        static let secondary = UIColor(hex: 0x555555)
        static let subHeader = UIColor(hex: 0x5C8D92)
    }
    
    struct Background {
        static let light = UIColor(hex: 0xF7F9FE)
        static let dark = UIColor(hex: 0x292E37)
        static let branch = UIColor(hex: 0xA9A9A9)
        static let header = UIColor(hex: 0xF7F7F7)
        static let seperator = UIColor(hex: 0xE9E9E9)
    }
    
    struct Sharpness {
        static let red = UIColor.red
        static let orange = UIColor.orange
        static let yellow = UIColor.yellow
        static let green = UIColor.green
        static let blue = UIColor.blue
        static let white = UIColor.white
        static let purple = UIColor.purple
    }
    
    static func setDefaults() {
        //UIView.appearance().backgroundColor = lightBackground
    }
}

struct Font {
    struct Size {
        static let header: CGFloat = 16
        static let title: CGFloat = 14
        static let subTitle: CGFloat = 12
    }
    
    static let header = UIFont.systemFont(ofSize: Size.header)
    static let title = UIFont.systemFont(ofSize: Size.title)
    static let titleMedium = UIFont.systemFont(ofSize: Size.title, weight: UIFont.Weight.medium)
    static let titleBold = UIFont.boldSystemFont(ofSize: Size.title)
    static let subTitle = UIFont.systemFont(ofSize: Size.subTitle)
}

extension UIColor {
    convenience init(hex: Int) {
        self.init(red: CGFloat((hex >> 16) & 0xff) / 255.0,
                  green: CGFloat((hex >> 8) & 0xff) / 255.0,
                  blue: CGFloat(hex & 0xff) / 255.0, alpha: 1)
    }
}
