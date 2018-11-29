//
//  ArmorSkill.swift
//  MHWDB
//
//  Created by Joe on 5/13/18.
//  Copyright © 2018 Gathering Hall Studios. All rights reserved.
//

import GRDB

class ArmorSkill: FetchableRecord, Decodable {
    let skillId: Int
    var name: String
    var value: Int

    enum CodingKeys: String, CodingKey {
        case skillId, name="skill_name", value="point_value"
    }
}

extension Database {
    func armorSkills(armorId: Int) -> [ArmorSkill] {
        let query = Query(table: "item_to_skill_tree")
            .column("skill_trees.name", as: "skill_name")
            .column("skill_trees._id", as: "skillId")
            .join(table: "items", on: "item_id")
            .join(table: "skill_trees", on: "skill_tree_id")
            .filter("item_id", equals: armorId)
        return fetch(query)
    }
}
