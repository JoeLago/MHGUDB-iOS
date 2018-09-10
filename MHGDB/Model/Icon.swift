//
//  Icon.swift
//  MHGUDB
//
//  Created by Joe on 9/10/18.
//  Copyright © 2018 Gathering Hall Studios. All rights reserved.
//

import GRDB
import UIKit

struct Icon {
    let name: String
    let color: Color?

    init(row: Row) {
        name = row["icon_name"] ?? "icon_quest_mark"
        color = Color(rawValue: row["icon_color"]) ?? .white
    }

    enum Color: Int {
        case white, red, green, blue, yellow, purple, cyan, orange, pink, yellowGreen, grey, gold, teal, darkGreen, darkRed, darkBlue, darkPurple

        var color: UIColor {
            switch self {
            case .white: return UIColor(hex: 0xffffff)
            case .red: return UIColor(hex: 0xf85858)
            case .green:  return UIColor(hex: 0x70c888)
            case .blue:  return UIColor(hex: 0x90b0f8)
            case .yellow:  return UIColor(hex: 0xf8d058)
            case .purple:  return UIColor(hex: 0xb890c0)
            case .cyan:  return UIColor(hex: 0x98d8f0)
            case .orange:  return UIColor(hex: 0xf89858)
            case .pink:  return UIColor(hex: 0xe890a0)
            case .yellowGreen:  return UIColor(hex: 0xc6f29f)
            case .grey:  return UIColor(hex: 0xa0a0a0)
            case .gold:  return UIColor(hex: 0xe2a626)
            case .teal:  return UIColor(hex: 0x5cccff)
            case .darkGreen:  return UIColor(hex: 0x639929)
            case .darkRed:  return UIColor(hex: 0xaa3c3c)
            case .darkBlue:  return UIColor(hex: 0x4066bb)
            case .darkPurple:  return UIColor(hex: 0x803a8e)
            }
        }
    }
}
