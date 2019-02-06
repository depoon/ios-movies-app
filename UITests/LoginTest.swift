//
//  LoginTest.swift
//  UITests
//
//  Created by Kenneth Poon on 29/12/18.
//  Copyright © 2018 Mohamed Elkamhawi. All rights reserved.
//

import XCTest
import SwiftLocalhost
import URLRequest_cURL

class LoginTest: XCTestCase {
    
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
        self.gaRequestLoggingServer.stopListening()
    }
    
    func testLoginSuccess() {
        
        self.localhostServer.route(method: .GET,
                                   path: "/3/movie/popular",
                                   responseData: ResponseDataFactory.responseData(filename: "home_popular"))
        self.localhostServer.route(method: .POST,
                                   path: "/identitytoolkit/v3/relyingparty/verifyPassword",
                                   responseData: ResponseDataFactory.responseData(filename: "firebase_verifyPassword_success"))
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
        
        XCUIApplication().textFields["emailField"].waitForExistence(timeout: 3)
        
        XCUIApplication().textFields["emailField"].tap()
        XCUIApplication().textFields["emailField"].typeText("apple@gmail.com")
        XCUIApplication().secureTextFields["passwordField"].tap()
        XCUIApplication().secureTextFields["passwordField"].typeText("password")
        XCUIApplication().buttons["loginButton"].tap()

        let successMessageExists = XCUIApplication().staticTexts["Login Success"].waitForExistence(timeout: 2)
        XCTAssert(successMessageExists)
        XCUIApplication().alerts.buttons["OK"].tap()
        
        
        //----- Assert Requests Fired -----------------
        
            //#### By URL Paths---------
            let expectedRequestPaths: [String] = [
                "/3/movie/popular",
                "/identitytoolkit/v3/relyingparty/verifyPassword",
                "/identitytoolkit/v3/relyingparty/getAccountInfo"
            ]
            let actualRequestPaths = self.localhostServer.recordedRequests.map {
                return $0.url!.path
            }
            XCTAssertEqual(expectedRequestPaths, actualRequestPaths)
        
        
        
        
        
        
            //#### By describing cURL commands ---------
            let expectedCURLs: [String] = [
                "curl -X GET \'http://localhost:\(self.localhostServer.portNumber)/3/movie/popular?api_key=71bb781f1fac0db70544bfe4f51262dc&page=1\'",
                "curl -X POST \'http://localhost:\(self.localhostServer.portNumber)/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyAV1g8U6jId2nHpz7Enp_owR7nzgsjDq2A\' -d \'{\n  \"email\" : \"apple@gmail.com\",\n  \"password\" : \"password\",\n  \"returnSecureToken\" : true\n}\'",
                "curl -X POST \'http://localhost:\(self.localhostServer.portNumber)/identitytoolkit/v3/relyingparty/getAccountInfo?key=AIzaSyAV1g8U6jId2nHpz7Enp_owR7nzgsjDq2A\' -d \'{\n  \"idToken\" : \"eyJhbGciOiJSUzI1NiIsImtpZCI6ImIzMmIyNzViNDBhOWFjNGU1ZmQ0NTFhZTUxMDE4ZThlOTgxMmViNDYiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vYmRkLXNpbXBsZWFwcGRlbW8iLCJhdWQiOiJiZGQtc2ltcGxlYXBwZGVtbyIsImF1dGhfdGltZSI6MTU0NjA2NTc2NCwidXNlcl9pZCI6IldObG5mUFo5eEZQN2x5YklkdnoyaUVMeEpxYTIiLCJzdWIiOiJXTmxuZlBaOXhGUDdseWJJZHZ6MmlFTHhKcWEyIiwiaWF0IjoxNTQ2MDY1NzY1LCJleHAiOjE1NDYwNjkzNjUsImVtYWlsIjoiYWxwaGEyQGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJlbWFpbCI6WyJhbHBoYTJAZ21haWwuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.Tw8GCcUdaS-qR3eLJdLJJd3AeQFbO1x_15bT3VofnMOmDbkAOEfUcMWp_zJkVKxVQf6tQ1xnMBb2bK-HE5X78OwUQKTQXo7Sqth_Oq9RWoZsQFFWKPjp6gcBGAsV6UW7Y8mDnRw12OvP5u1iQmZe2l4FZtGSjOvaHyAOV4FIyQn3A1ZCdkttAEhCoS_Hoq2DR94pDwlNDOe--eXNzi7Y2NRq_Rqs6_MHbydcl4GbTn4YWTRBedfdduh862CyAECQXVtlFtnAJYk5Tm7DkAPKjZLeTMSByr8TZJGtGPo-LY0Hy3UevdXYC1WW_0ERFdSMRXurxGUNPasUjjlMBF_-5w\"\n}\'"
            ]
            let actualCURLs = self.localhostServer.recordedRequests.map {
                return $0.cURL(withHeaders: false)
            }
            XCTAssertEqual(expectedCURLs, actualCURLs)
        
        Thread.sleep(forTimeInterval: 1)
        
        //----- Assert GA Events Fired -----------------
            let expected = GARequestLoggingReport(payloads: [
                GARequestPayload.screenView(zIdentifier: nil, screenName: "Login"),
                GARequestPayload.event(zIdentifier: nil, category: "Login+Module", action: "Tapped", label: "Login+Button")
                ])
            let actual = self.gaRequestLoggingServer.eventsReport()
            XCTAssertEqual(expected, actual)
        
    }
    
}
