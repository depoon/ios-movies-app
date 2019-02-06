//
//  RegistrationTest.swift
//  UITests
//
//  Created by Kenneth Poon on 29/12/18.
//  Copyright © 2018 Mohamed Elkamhawi. All rights reserved.
//

import XCTest
import SwiftLocalhost

class RegistrationTest: XCTestCase {
    
    var localhostServer: LocalhostServer!
    var gaRequestLoggingServer: GARequestLoggingServer!
    
    override func setUp() {
        continueAfterFailure = false
        self.localhostServer = LocalhostServer.initializeUsingRandomPortNumber()
        self.localhostServer.startListening()
        
        self.gaRequestLoggingServer = GARequestLoggingServer.initializeUsingRandomPortNumber()
        self.gaRequestLoggingServer.startListening()
        XCUIApplication().deleteApp()
    }
    
    override func tearDown() {
        self.localhostServer.stopListening()
    }
    
    func testRegistrationSuccess() {
        self.localhostServer.route(method: .GET,
                                   path: "/3/movie/popular",
                                   responseData: ResponseDataFactory.responseData(filename: "home_popular"))
        self.localhostServer.route(method: .POST,
                                   path: "/identitytoolkit/v3/relyingparty/signupNewUser",
                                   responseData: ResponseDataFactory.responseData(filename: "firebase_signupNewUser_success"))
        self.localhostServer.route(method: .POST,
                                   path: "/identitytoolkit/v3/relyingparty/getAccountInfo",
                                   responseData: ResponseDataFactory.responseData(filename: "firebase_getAccountInfo_success"))
        
        let app = XCUIApplication()
        app.launchArguments = ["port:\(self.localhostServer.portNumber)",
                                "gaport:\(self.gaRequestLoggingServer.portNumber)"]
        app.launch()
        
        if XCUIApplication().buttons["Logout"].exists {
            XCUIApplication().buttons["Logout"].tap()
        }
        XCUIApplication().buttons["Login"].tap()
        XCUIApplication().buttons["Register"].tap()
        
        XCUIApplication().textFields["emailField"].tap()
        XCUIApplication().textFields["emailField"].typeText("apple@gmail.com")
        XCUIApplication().secureTextFields["passwordField"].tap()
        XCUIApplication().secureTextFields["passwordField"].typeText("password")
        XCUIApplication().buttons["registerButton"].tap()
        
        let successMessageExists = XCUIApplication().staticTexts["Success!"].waitForExistence(timeout: 3)
        XCTAssert(successMessageExists)
        XCUIApplication().alerts.buttons["OK"].tap()
        XCUIApplication().staticTexts["Login"].waitForExistence(timeout: 2)
        
        let expected = GARequestLoggingReport(payloads: [
            GARequestPayload.screenView(zIdentifier: nil, screenName: "Login"),
            GARequestPayload.event(zIdentifier: nil, category: "Login+Module", action: "Tapped", label: "Register+Button"),
            GARequestPayload.screenView(zIdentifier: nil, screenName: "Registration"),
            GARequestPayload.event(zIdentifier: nil, category: "Registration+Module", action: "Tapped", label: "Register+Button"),
            GARequestPayload.screenView(zIdentifier: nil, screenName: "Login"),
            ])
        let actual = self.gaRequestLoggingServer.eventsReport()
        XCTAssertEqual(expected, actual)

    }
    
}

