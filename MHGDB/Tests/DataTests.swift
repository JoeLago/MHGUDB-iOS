//
//  DataTests.swift
//  MHGDB
//
//  Created by Joe on 10/22/17.
//  Copyright © 2017 Gathering Hall Studios. All rights reserved.
//


import XCTest
@testable import MHGDB

class DataTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testQuerySerialization() {
        _ = Database.shared.armor()
        _ = Database.shared.combinations()
        _ = Database.shared.components(itemId: 2)
        _ = Database.shared.decorations()
        _ = Database.shared.items()
        _ = Database.shared.locations()
        _ = Database.shared.monsters()
        _ = Database.shared.palicoWeapons()
        _ = Database.shared.quests()
        _ = Database.shared.skillTrees()
        _ = Database.shared.weapons("")
    }
    
    func testSearch() {
        let results = SearchRequest("m").search()
        XCTAssertNotNil(results)
        XCTAssert(results?.monsters.count ?? 0 > 0)
    }
}
