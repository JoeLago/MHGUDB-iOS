//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation
import GRDB

class Elements {
    var state: String?
    var fire = 0
    var water = 0
    var thunder = 0
    var ice = 0
    var dragon = 0
    var poison = 0
}

class Resistances: Elements, RowConvertible {
    required init(row: Row) {
        super.init()
        fire = row["fire_res"]
        water = row["water_res"]
        thunder = row["thunder_res"]
        ice = row["ice_res"]
        dragon = row["dragon_res"]
    }
}
