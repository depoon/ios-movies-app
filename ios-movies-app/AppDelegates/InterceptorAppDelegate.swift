//
//  InterceptorAppDelegate.swift
//  ios-movies-app
//
//  Created by Kenneth Poon on 16/12/18.
//  Copyright © 2018 Mohamed Elkamhawi. All rights reserved.
//

import Foundation
import UIKit
import NetworkInterceptor
// https://github.com/depoon/NetworkInterceptor

class InterceptorAppDelegate:  NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let requestSniffers: [RequestSniffer] = [
            RequestSniffer(requestEvaluator: AnyHttpRequestEvaluator(), handlers: [
                SniffableRequestHandlerRegistrable.console(logginMode: .print).requestHandler()
                ])
        ]
        var requestRedirectors: [RequestRedirector] = []
        if let port = ProcessInfo.infoValue(for: "port") { // assuming localhost is active
            requestRedirectors.append(
                RequestRedirector(requestEvaluator: DomainHttpRequestEvaluator(domain: "www.googleapis.com"),
                                  redirectableRequestHandler: AlternateDomainRequestRedirector(domainURL: URL(string: "http://localhost:\(port)")!))
            )
        }
        if let gaport = ProcessInfo.infoValue(for: "gaport") { // assuming localhost is active
            requestRedirectors.append(
                RequestRedirector(requestEvaluator: DomainHttpRequestEvaluator(domain: "ssl.google-analytics.com"),
                                  redirectableRequestHandler: AlternateDomainRequestRedirector(domainURL: URL(string: "http://localhost:\(gaport)")!))
            )
        }
        
        let networkConfig = NetworkInterceptorConfig(requestSniffers: requestSniffers,
                                                     requestRedirectors: requestRedirectors)
        NetworkInterceptor.shared.setup(config: networkConfig)
        NetworkInterceptor.shared.startRecording()
        
        return true
    }
}
