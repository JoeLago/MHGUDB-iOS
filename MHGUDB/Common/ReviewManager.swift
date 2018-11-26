//
//  ReviewManager.swift
//  MHGDB
//
//  Created by Joe on 9/24/17.
//  Copyright © 2017 Gathering Hall Studios. All rights reserved.
//

import Foundation
import StoreKit
import SwiftyUserDefaults

class ReviewManager {
    struct Constants {
        static let firstReviewMinLaunchCount = 5
        static let firstReviewMinTimeInterval = 2.days
        static let repeatReviewMinLaunchCount = 10
        static let repeatReviewMinTimeInterval = 10.days
    }
    
    @available(iOS 10.3, *)
    static func presentReviewControllerIfElligible() {
        if ReviewManager.isElligibleForReview {
            SKStoreReviewController.requestReview()
            Defaults[.lastReviewRequestDate] = Date()
            Defaults[.lastReviewRequestLaunchCount] = Defaults[.launchCount]
        }
    }
    
    static var isElligibleForReview: Bool {
        return isElligibleForReview(
            currDate: Date(),
            firstLaunchDate: Defaults[.firstLaunchDate],
            launchCount: Defaults[.launchCount],
            lastReviewRequestDate: Defaults[.lastReviewRequestDate],
            lastReviewRequestLaunchCount: Defaults[.lastReviewRequestLaunchCount])
    }
    
    static func isElligibleForReview(currDate: Date, firstLaunchDate: Date?, launchCount: Int, lastReviewRequestDate: Date?, lastReviewRequestLaunchCount: Int) -> Bool {
        if let lastReviewRequestDate = lastReviewRequestDate {
            if lastReviewRequestDate.addingTimeInterval(Constants.firstReviewMinTimeInterval) <= currDate,
                launchCount - lastReviewRequestLaunchCount >= Constants.repeatReviewMinLaunchCount  {
                return true
            }
        } else {
            if let firstLaunchDate = firstLaunchDate,
                firstLaunchDate.addingTimeInterval(Constants.firstReviewMinTimeInterval) <= currDate,
                launchCount >= Constants.firstReviewMinLaunchCount {
                return true
            }
        }
        
        return false
    }
}
