//
//  ImagePreload.swift
//  MHGUDB
//
//  Created by Joe on 11/22/18.
//  Copyright © 2018 Gathering Hall Studios. All rights reserved.
//

import UIKit

extension Database {
    private var otherImages: [String] {
        return ["Fire", "Water", "Ice", "Thunder", "Dragon", "Poison", "Sleep", "Paralysis", "Stun", "exhaust", "mount", "jump", "Blastblight"]
    }

    func preloadImages(named: [String]) -> Int {
        for imageName in named {
            //_ = UIImage(named: iconName) // This takes 4x as long!
            _ = UIImage(named: imageName, in: nil, compatibleWith: nil)
        }
        return named.count
    }

    func preloadImages(table: String, columnName: String = "icon_name") -> Int {
        let query = "SELECT \(columnName) FROM \(table) GROUP BY \(columnName)"
        let iconNames = getStrings(query, column: columnName)
        return preloadImages(named: iconNames)
    }

    func preloadImages() {
        let start = Date().timeIntervalSince1970
        var count = 0
        count += preloadImages(named: Weapon.WType.allValues.compactMap({ $0.icon?.name }))
        count += preloadImages(table: "monsters")
        count += preloadImages(named: otherImages)
        count += preloadImages(table: "items")
        count += preloadImages(table: "locations", columnName: "map")
        Log("Preloaded \(count) images in \(Date().timeIntervalSince1970 - start) seconds")
    }

    func preloadImagesInBackground() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.preloadImages()
        }
    }
}
