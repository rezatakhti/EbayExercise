//
//  FeedImageView_Tests.swift
//  RecordListTests
//
//  Created by Takhti, Gholamreza on 8/27/22.
//

import XCTest
@testable import RecordList

class FeedImageView_Tests: XCTestCase {
    
    var feedImageView: FeedImageView?

    override func setUpWithError() throws {
        feedImageView = FeedImageView()
    }

    override func tearDownWithError() throws {
        feedImageView = nil
    }

    func testImageLoading() throws {
        //random image string to test
        let imageString = "https://is3-ssl.mzstatic.com/image/thumb/Music122/v4/7b/6c/7d/7b6c7d04-86f6-a62a-26d1-66d293125982/196589286376.jpg/100x100bb.jpg"
        let expectation = self.expectation(description: "Get Feed")
        feedImageView?.loadImage(at: imageString, completion: { _ in
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(feedImageView?.image)
    }
}
