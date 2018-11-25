//
//  FavoritesScreen.swift
//  MHGUDB
//
//  Created by Joe on 10/23/18.
//  Copyright © 2018 Gathering Hall Studios. All rights reserved.
//

import Foundation


import UIKit

class BookmarksScreen: DetailController {
    override func loadView() {
        super.loadView()
        title = "Bookmarks"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sections.removeAll()
        addSimpleSection(data: Database.shared.bookmarkedWeapons()) { WeaponDetails($0) }
        reloadData()
    }
}
