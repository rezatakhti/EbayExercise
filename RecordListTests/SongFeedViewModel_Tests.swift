//
//  SongFeedViewModel_Tests.swift
//  RecordListTests
//
//  Created by Takhti, Gholamreza on 8/27/22.
//

import XCTest
@testable import RecordList

class SongFeedViewModel_Tests: XCTestCase {
    
    var viewModel : SongFeedViewModel?

    override func setUpWithError() throws {
        viewModel = SongFeedViewModel(service: SongFeedService())
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testGetFeed(){
        let expectation = self.expectation(description: "Get Feed")
        viewModel?.loadData(completion: { _ in
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel?.getFeedItems().count, 10)
    }
    
    func testTitle() {
        let expectation = self.expectation(description: "Title")
        viewModel?.loadData(completion: { _ in
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(viewModel?.title)
    }
}
