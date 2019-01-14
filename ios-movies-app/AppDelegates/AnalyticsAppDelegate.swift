//
//  AnalyticsAppDelegate.swift
//  ios-movies-app
//
//  Created by Kenneth Poon on 30/12/18.
//  Copyright © 2018 Mohamed Elkamhawi. All rights reserved.
//

import Foundation
import UIKit

class AnalyticsAppDelegate:  NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AnalyticsManager.shared.setup()
        return true
    }
}

class AnalyticsManager: NSObject {
    
    static let shared = AnalyticsManager()
    
    func setup(){
        let gai = GAI.sharedInstance()
        _ = gai?.tracker(withTrackingId: "UA-123889876-1")
        gai?.trackUncaughtExceptions = true
        gai?.logger.logLevel = .verbose
        gai?.dispatchInterval = 0.01
    }
    
    func trackEvent(category: String, action: String, label: String, value: Int? = nil) {
        guard
            let tracker = GAI.sharedInstance().defaultTracker,
            let builder = GAIDictionaryBuilder.createEvent(withCategory: category, action: action, label: label, value: nil)
            else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func trackScreenView(screenName: String) {
        let screenViewParameters = GAIDictionaryBuilder.createScreenView().set(screenName, forKey: kGAIScreenName).build()
        GAI.sharedInstance().defaultTracker.send(screenViewParameters as! [AnyHashable : Any])
    }
    
}
