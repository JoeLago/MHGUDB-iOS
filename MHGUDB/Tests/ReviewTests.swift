//
//  ReviewTests.swift
//  MHGDB
//
//  Created by Joe on 9/24/17.
//  Copyright © 2017 Gathering Hall Studios. All rights reserved.
//


import XCTest
@testable import MHGDB

class ReviewTests: XCTestCase {
    
    func testReviewTiming() {
        let currDate = Date()
        let fourtyDaysAgo = Date().addingTimeInterval(-40.days)
        let tenDaysAgo = Date().addingTimeInterval(-10.days)
        let oneDaysAgo = Date().addingTimeInterval(-1.days)
        
        // First review tests
        
        XCTAssertFalse(ReviewManager.isElligibleForReview(
            currDate: currDate,
            firstLaunchDate: currDate,
            launchCount: 1,
            lastReviewRequestDate: nil,
            lastReviewRequestLaunchCount: 0))
        
        XCTAssertFalse(ReviewManager.isElligibleForReview(
            currDate: currDate,
            firstLaunchDate: fourtyDaysAgo,
            launchCount: 4,
            lastReviewRequestDate: nil,
            lastReviewRequestLaunchCount: 0))
        
        XCTAssertFalse(ReviewManager.isElligibleForReview(
            currDate: currDate,
            firstLaunchDate: oneDaysAgo,
            launchCount: 10000,
            lastReviewRequestDate: nil,
            lastReviewRequestLaunchCount: 0))
        
        XCTAssertTrue(ReviewManager.isElligibleForReview(
            currDate: currDate,
            firstLaunchDate: tenDaysAgo,
            launchCount: 5,
            lastReviewRequestDate: nil,
            lastReviewRequestLaunchCount: 0))
        
        // Repeat review tests
        
        XCTAssertTrue(ReviewManager.isElligibleForReview(
            currDate: currDate,
            firstLaunchDate: fourtyDaysAgo,
            launchCount: 50,
            lastReviewRequestDate: fourtyDaysAgo,
            lastReviewRequestLaunchCount: 5))
        
        XCTAssertFalse(ReviewManager.isElligibleForReview(
            currDate: currDate,
            firstLaunchDate: fourtyDaysAgo,
            launchCount: 6,
            lastReviewRequestDate: fourtyDaysAgo,
            lastReviewRequestLaunchCount: 5))
    }
}
