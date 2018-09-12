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

    static func iconQueryAttributes(table: String = "items") -> String {
        return " \(table).icon_name as icon_name, \(table).icon_color as icon_color"
    }

    init(row: Row) {
        name = row["icon_name"] ?? "icon_quest_mark"
        color = Color(rawValue: row["icon_color"]) ?? .white
    }

    init?(name: String?, colorType: Int) {
        self.init(name: name, color: Color(rawValue: colorType))
    }

    init?(name: String?, color: Color? = nil) {
        self.name = name ?? "icon_quest_mark"
        self.color = color ?? .white
    }

    init(name: String, rarity: Int) {
        self.name = name
        self.color = Color(rarity: rarity)
    }

    enum Color: Int {
        case white, red, green, blue, yellow, purple, cyan, orange, pink, yellowGreen, grey, gold, teal, darkGreen, darkRed, darkBlue, darkPurple, rare1, rare2, rare3, rare4, rare5, rare6, rare7, rare8, rare9, rare10, rare11

        init(rarity: Int) {
            switch rarity {
            case 1: self = .rare1
            case 2: self = .rare2
            case 3: self = .rare3
            case 4: self = .rare4
            case 5: self = .rare5
            case 6: self = .rare6
            case 7: self = .rare7
            case 8: self = .rare8
            case 9: self = .rare9
            case 10: self = .rare10
            case 11: self = .rare11
            default: self = .rare1
            }
        }

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
            case .rare1:  return UIColor(hex: 0x757575)
            case .rare2:  return UIColor(hex: 0xB53BC6)
            case .rare3:  return UIColor(hex: 0xFBD646)
            case .rare4:  return UIColor(hex: 0xF287A2)
            case .rare5:  return UIColor(hex: 0x57D284)
            case .rare6:  return UIColor(hex: 0x90b0f8)
            case .rare7:  return UIColor(hex: 0xFF3E56)
            case .rare8:  return UIColor(hex: 0x9ACCFF)
            case .rare9:  return UIColor(hex: 0xFF9A53)
            case .rare10:  return UIColor(hex: 0xFF33FF)
            case .rare11:  return UIColor(hex: 0x5834b8)
            }
        }

        /*

 @JvmStatic fun getNoteColor(note: Char): Int {
 when (note) {
 'B' -> return R.color.item_dark_blue
 'C' -> return R.color.item_cyan
 'G' -> return R.color.item_dark_green
 'O' -> return R.color.item_orange
 'P' -> return R.color.item_dark_purple
 'R' -> return R.color.item_dark_red
 'W' -> return R.color.item_white
 'Y' -> return R.color.item_yellow
 }
 return R.color.item_white
 }
 */
    }
}
