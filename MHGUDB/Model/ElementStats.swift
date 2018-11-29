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

class Resistances: Elements, FetchableRecord {
    required init(row: Row) {
        super.init()
        fire = row["fire_res"]
        water = row["water_res"]
        thunder = row["thunder_res"]
        ice = row["ice_res"]
        dragon = row["dragon_res"]
    }

    init(fire: Int, water: Int, thunder: Int, ice: Int, dragon: Int, poison: Int = 0) {
        super.init()
        self.fire = fire
        self.water = water
        self.thunder = thunder
        self.ice = ice
        self.dragon = dragon
        self.poison = poison
    }
}
