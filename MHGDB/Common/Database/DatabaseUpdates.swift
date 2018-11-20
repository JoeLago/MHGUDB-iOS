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
        //try updateV1()
    }

    func updateV1() {
        write("""
        CREATE TABLE "weapon_favorites" (
            "weapon_id" integer NOT NULL,
            FOREIGN KEY ("weapon_id") REFERENCES "weapon"("_id")
        );
        """)
    }
}
