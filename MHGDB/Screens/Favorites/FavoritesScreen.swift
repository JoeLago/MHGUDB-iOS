//
//  FavoritesScreen.swift
//  MHGUDB
//
//  Created by Joe on 10/23/18.
//  Copyright © 2018 Gathering Hall Studios. All rights reserved.
//

import Foundation


import UIKit

class FavoritesList: DetailController {
    override func loadView() {
        super.loadView()
        title = "Favorites"
        addSimpleSection(data: Database.shared.favoriteWeapons()) { WeaponDetails($0) }
    }
}
