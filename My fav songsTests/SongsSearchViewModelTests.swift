//
//  SongsSearchViewModelTests.swift
//  My fav songsTests
//
//  Created by Karol Ch on 18/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import XCTest
@testable import My_fav_songs

class SongsSearchViewModelTests: XCTestCase {
    
    var viewModel: SongsSearchViewModel!
    var mockAPIService: MockApiService!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockApiService()
        viewModel = SongsSearchViewModel(apiService: mockAPIService, appDelegate: AppDelegate())
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func test_fetch_songs() {
        mockAPIService.completeResult = ResultData(resultCount: Int(), results: [Song]())
        viewModel.searchForSongs("Krawczyk")
        XCTAssert(mockAPIService!.isFetchSongsCalled)
    }
    
    func test_create_cell_view_model() {
        // Given
        let result = StubGenerator().stubSongs()
        mockAPIService.completeResult = result
        let expect = XCTestExpectation(description: "reload closure triggered")
        viewModel.reloadTableViewClosure = { () in
            expect.fulfill()
        }
        
        // When
        viewModel.searchForSongs("Zbigniew Wodecki")
        mockAPIService.fetchSuccess()
        
        // Number of cell view model is equal to the number of photos
        XCTAssertEqual(viewModel.numberOfCells, result.results.count)
        
        // XCTAssert reload closure triggered
        wait(for: [expect], timeout: 1.0)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

extension SongsSearchViewModelTests {
    private func goToFetchSongFinished() {
        mockAPIService.completeResult = StubGenerator().stubSongs()
        viewModel.searchForSongs("Krawczyk")
        mockAPIService.fetchSuccess()
    }
}

class MockApiService: APIProtocol {
    
    var isFetchSongsCalled = false
    
    var completeResult = ResultData(resultCount: Int(), results: [Song]())
    var successClosure: ((ResultData) -> ())!
    var failClosure: ((Error) -> ())!
    
    func fetchSongs(query: String, onSuccess: @escaping (ResultData) -> Void, onFailure: @escaping (Error) -> Void) {
        isFetchSongsCalled = true
        successClosure = onSuccess
    }
    
    func fetchSuccess() {
        successClosure(completeResult)
    }
    
    func fetchFail(error: Error.Type) {
        failClosure(error as! Error)
    }
    
}

class StubGenerator {
    func stubSongs() -> ResultData {
        let path = "https://itunes.apple.com/search?term=Laki%20lan&limit=25&medium=music"
        var songs: ResultData?
        do {
            let data = try! Data(contentsOf: URL(string: path)!)
            songs = try JSONDecoder().decode(ResultData.self, from: data)
        } catch let error {
            print(error)
        }
        return songs!
    }
}

