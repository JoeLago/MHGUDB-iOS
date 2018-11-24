//
//  DatabaseUpdates.swift
//  MHGUDB
//
//  Created by Joe on 10/23/18.
//  Copyright © 2018 Gathering Hall Studios. All rights reserved.
//

import Foundation
import GRDB

extension Database {

    func update() {
        let version = (fetch("SELECT * FROM Version") as Version?)?.version ?? 0

        if version < 1 { updateV1() }
        // create version fucntion below and call from here

        update(version: 1)
    }

    func update(version: Int) {
        write("UPDATE Version set version=?", arguments: [version])
    }

    func updateV1() {
        // These should probably throw on failure so we try again
        write("CREATE TABLE version (version integer NOT NULL)")
        write("INSERT INTO Version (version) VALUES (0)")
        write("CREATE TABLE weapon_favorites (weapon_id integer NOT NULL)")
        //FOREIGN KEY (weapon_id) REFERENCES weapons(_id)
    }
}

private class Version: RowConvertible {
    let version: Int
    required init(row: Row) {
        version = row["version"] ?? 0
    }
}
