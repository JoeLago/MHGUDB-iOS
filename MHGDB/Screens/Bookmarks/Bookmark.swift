//
//  Bookmark.swift
//  MHGUDB
//
//  Created by Joe on 11/24/18.
//  Copyright © 2018 Gathering Hall Studios. All rights reserved.
//

import Foundation
import GRDB

extension Database {

    func bookmarkItem(id: Int) {
        let query = isBookmarked(itemId: id)
            ? "DELETE FROM item_favorites WHERE item_id=(\(id))"
            : "INSERT INTO item_favorites VALUES (\(id))"
        write(query)
    }

    func isBookmarked(itemId: Int) -> Bool {
        let query = "SELECT EXISTS(SELECT 1 FROM item_favorites WHERE item_id=\(itemId) LIMIT 1)"
        return fetchBool(query) ?? false
    }

    func bookmarkedItems() -> [Item] {
        return fetch("SELECT * FROM item_favorites"
            + " LEFT JOIN items on item_favorites.item_id = items._id")
    }
}
