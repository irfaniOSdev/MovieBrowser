//
//  MovieBrowserTests.swift
//  MovieBrowserTests
//
//  Created by Irfan on 21/04/2019.
//  Copyright © 2019 Irfan. All rights reserved.
//

import XCTest
@testable import MovieBrowser
class MovieBrowserTests: XCTestCase {
    
    
    func testGettingJSON() {
        let ex = expectation(description: "Expecting Movies not nil")
        
          NetworkManager.sharedInstance.getMoviesRequest() { (hasMovies, movies, text) in
            do {
                XCTAssertNotNil(movies)
                ex.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
       
    }
    
   
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
