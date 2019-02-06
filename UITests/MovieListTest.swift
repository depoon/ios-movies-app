//
//  MovieListTest.swift
//  UITests
//
//  Created by Kenneth Poon on 17/12/18.
//  Copyright © 2018 Mohamed Elkamhawi. All rights reserved.
//

import XCTest
import SwiftLocalhost
// https://github.com/depoon/SwiftLocalhost

class MovieListTest: XCTestCase {
    
    var localhostServer: LocalhostServer!
    
    override func setUp() {
        continueAfterFailure = false
        self.localhostServer = LocalhostServer.initializeUsingRandomPortNumber()
        self.localhostServer.startListening()
        XCUIApplication().deleteApp()
    }
    
    override func tearDown() {
        self.localhostServer.stopListening()
    }
    
    func testMoviePopularList() {
        self.localhostServer.route(method: .GET,
                                   path: "/3/movie/popular",
                                   responseData: ResponseDataFactory.responseData(filename: "home_popular"))
        
        let app = XCUIApplication()
        app.launchArguments = ["port:\(self.localhostServer.portNumber)"]
        app.launch()
        
        //----- UI Execution   ------------------------
            XCTAssert(isMoviePoster(index: 0, movieName: "Fantastic Beasts: The Crimes of Grindelwald"))
            XCTAssert(isMoviePoster(index: 1, movieName: "Mission: Impossible - Fallout"))
            XCTAssert(isMoviePoster(index: 2, movieName: "Bohemian Rhapsody"))
        
        

        //----- Assert Requests Fired -----------------
            let expectedRequestPaths: [String] = [
                "/3/movie/popular"
            ]
            let actualRequestPaths = self.localhostServer.recordedRequests.map {
                return $0.url!.path
            }
            XCTAssertEqual(expectedRequestPaths, actualRequestPaths)

    }

    func testMovieUpcomingList() {
        self.localhostServer.route(method: .GET,
                                   path: "/3/movie/popular",
                                   responseData: ResponseDataFactory.responseData(filename: "home_popular"))
        self.localhostServer.route(method: .GET,
                                   path: "/3/movie/upcoming",
                                   responseData: ResponseDataFactory.responseData(filename: "home_upcoming"))
        let app = XCUIApplication()
        app.launchArguments = ["port:\(self.localhostServer.portNumber)"]
        app.launch()
        
        
        
        //----- UI Execution   ------------------------
            XCUIApplication().segmentedControls.buttons["Upcoming"].tap()
        
            XCTAssert(isMoviePoster(index: 0, movieName: "The Equalizer 2"))
            XCTAssert(isMoviePoster(index: 1, movieName: "The Seven Deadly Sins: Prisoners of the Sky"))
        
        
        //----- Assert Requests Fired -----------------
            let expectedRequestPaths: [String] = [
                "/3/movie/popular",
                "/3/movie/upcoming"
            ]
            let actualRequestPaths = self.localhostServer.recordedRequests.map {
                return $0.url!.path
            }
            XCTAssertEqual(expectedRequestPaths, actualRequestPaths)
    }
    
    func isMoviePoster(index: Int, movieName: String) -> Bool {
        let result = XCUIApplication()
                .collectionViews
                .cells.element(boundBy: index)
                .otherElements[movieName]
                .waitForExistence(timeout: 2)
        return result
    }
}

