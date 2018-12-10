//
//  Icon.swift
//  MHGUDB
//
//  Created by Joe on 9/10/18.
//  Copyright © 2018 Gathering Hall Studios. All rights reserved.
//

import GRDB
import UIKit

struct Icon: Decodable {
    let name: String
    let color: Color?

    public static func iconQueryAttributes(table: String = "items", prefix: String = "") -> String {
        return " \(table).icon_name as \(prefix)icon_name, \(table).icon_color as \(prefix)icon_color"
    }

    init(row: Row, prefix: String = "") {
        name = row["\(prefix)icon_name"] ?? "icon_quest_mark"
        if let type: String = row["type"], (type == "Weapon" || type == "Armor") {
            color = Color(rarity: row["rarity"])
        } else {
            color = Color(rawValue: row["\(prefix)icon_color"]) ?? .white
        }
    }

    init?(name: String?, colorType: Int) {
        self.init(name: name, color: Color(rawValue: colorType))
    }

    init(name: String, rarity: Int) {
        self.name = name
        self.color = Color(rarity: rarity)
    }

    init?(name: String?, color: Color? = nil) {
        self.name = name ?? "icon_quest_mark"
        self.color = color ?? .white
    }

    init(name: String, color: Color? = nil) {
        self.name = name
        self.color = color ?? .white
    }

    var image: UIImage? {
        guard var image = UIImage(named: name, in: nil, compatibleWith: nil) else {
            return nil
        }
        if let color = color?.color {
            image = image.tint(color)
        }
        return image
    }

    enum Color: Int, Decodable {
        case white, red, green, blue, yellow, purple, cyan, orange, pink, yellowGreen, grey, gold, teal, darkGreen, darkRed, darkBlue, darkPurple, rare1, rare2, rare3, rare4, rare5, rare6, rare7, rare8, rare9, rare10, rare11

        // Does it make more sense to have a RarityColor enum?
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
    }
}

extension Icon: Equatable {
    public static func == (lhs: Icon, rhs: Icon) -> Bool {
        return lhs.name == rhs.name && lhs.color == rhs.color
    }
}
