//
//  FirebaseAppDelegate.swift
//  ios-movies-app
//
//  Created by Kenneth Poon on 27/12/18.
//  Copyright © 2018 Mohamed Elkamhawi. All rights reserved.
//

import Foundation
import FirebaseCore

class FirebaseAppDelegate:  NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
