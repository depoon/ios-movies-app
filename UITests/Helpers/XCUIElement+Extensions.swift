//
//  XCUIElement+Extensions.swift
//  UITests
//
//  Created by Kenneth Poon on 26/12/18.
//  Copyright © 2018 Mohamed Elkamhawi. All rights reserved.
//

import Foundation
import XCTest

extension XCUIElement {
    func staticTextsExists(text: String) -> Bool {
        let predicate = NSPredicate(format: "label CONTAINS[c] '\(text)'")
        let anyElementsFound: Bool = XCUIApplication().staticTexts.containing(predicate).count == 0
        return anyElementsFound
    }
    
    func deleteApp() {
        XCUIApplication().terminate()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        
        // Force delete the app from the springboard
        let icon = springboard.icons["ios-movies-app"]
        if icon.exists {
            let iconFrame = icon.frame
            let springboardFrame = springboard.frame
            icon.press(forDuration: 1.3)
            
            // Tap the little "X" button at approximately where it is. The X is not exposed directly
            let vector = CGVector(dx: (iconFrame.minX + 3) / springboardFrame.maxX, dy: (iconFrame.minY + 3) / springboardFrame.maxY)
            springboard.coordinate(withNormalizedOffset: vector).tap()

            springboard.alerts.buttons["Delete"].waitForExistence(timeout: 3)
            springboard.alerts.buttons["Delete"].tap()
        }
    }
}
