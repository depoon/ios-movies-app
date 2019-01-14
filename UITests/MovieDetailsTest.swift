//
//  MovieDetailsTest.swift
//  UITests
//
//  Created by Kenneth Poon on 24/12/18.
//  Copyright © 2018 Mohamed Elkamhawi. All rights reserved.
//

import XCTest
import SwiftLocalhost

class MovieDetailsTest: XCTestCase {
    
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
    
    func testDetails() {
        self.localhostServer.route(method: .GET,
                                   path: "/3/movie/popular",
                                   responseJsonFileName: "home_popular")
        self.localhostServer.route(method: .GET,
                                   path: "/3/movie/upcoming",
                                   responseJsonFileName: "home_upcoming")
        self.localhostServer.route(method: .GET,
                                   path: "/3/movie/345887",
                                   responseJsonFileName: "movie_details_equalizer")
        let app = XCUIApplication()
        app.launchArguments = ["port:\(self.localhostServer.portNumber)"]
        app.launch()
        
        
        //----- UI Execution   ------------------------
            XCUIApplication().segmentedControls.buttons["Upcoming"].tap()
            XCUIApplication().collectionViews.cells.element(boundBy: 0).tap()
            let exists = XCUIApplication().staticTextsExists(text: "Robert McCall, who serves an unflinching justice for the exploited and oppressed, embarks on a relentless, globe-trotting quest for vengeance when a long-time girl friend is murdered.")
            XCTAssert(exists)
        
        
        //----- Assert Requests Fired -----------------
            let expectedRequestPaths: [String] = [
                "/3/movie/popular",
                "/3/movie/upcoming",
                "/3/movie/345887"
            ]
            let actualRequestPaths = self.localhostServer.recordedRequests.map {
                return $0.url!.path
            }
            XCTAssertEqual(expectedRequestPaths, actualRequestPaths)
    }
    
}
