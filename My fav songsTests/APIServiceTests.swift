//
//  APIServiceTests.swift
//  My fav songsTests
//
//  Created by Karol Ch on 18/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import XCTest
@testable import My_fav_songs

class APIServiceTests: XCTestCase {
    
    var apiService: WebService?
    
    override func setUp() {
        super.setUp()
        apiService = WebService()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSongsFetch() {
        let webService = self.apiService!
        let expect = XCTestExpectation(description: "callback")
        webService.fetchSongs(query: "Johny Cash", onSuccess: { (data) in
            expect.fulfill()
            XCTAssertEqual(data.resultCount, data.results.count)
            for song in data.results {
                XCTAssertNotNil(song.artistName)
            }
        }, onFailure: { (error) in
        })
        wait(for: [expect], timeout: 2.0)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
