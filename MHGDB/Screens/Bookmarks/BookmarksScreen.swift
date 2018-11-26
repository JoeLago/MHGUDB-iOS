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
        addSimpleSection(data: Database.shared.bookmarkedItems()) {
            switch $0.type {
            case .weapon: return WeaponDetails(id: $0.id)
            case .armor: return ArmorDetails(id: $0.id)
            case .other: return ItemDetails(id: $0.id)
            }
        }
        reloadData()
    }
}
