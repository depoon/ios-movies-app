//
//  LocalhostServer+Router.swift
//  UITests
//
//  Created by Kenneth Poon on 22/12/18.
//  Copyright © 2018 Mohamed Elkamhawi. All rights reserved.
//

import Foundation
import SwiftLocalhost

extension LocalhostServer {
    enum ServerStepsHttpMethod: String {
        case GET, POST, PUT, DELETE
    }
    
    func route(method: LocalhostServer.ServerStepsHttpMethod,
               path: String,
               responseJsonFileName: String) {
        let routeBlock = self.routeBlock(path: path, responseFileName: responseJsonFileName)
        switch method {
        case .GET:
            self.get(path, routeBlock: routeBlock)
        case .POST:
            self.post(path, routeBlock: routeBlock)
        case .PUT:
            self.put(path, routeBlock: routeBlock)
        case .DELETE:
            self.delete(path, routeBlock: routeBlock)
        }
    }
    
    fileprivate func routeBlock(path: String, responseFileName: String) -> ((URLRequest) -> LocalhostServerResponse?) {
        let responseData = self.responseData(filename: responseFileName)
        let block: ((URLRequest) -> LocalhostServerResponse?) = { _ in
            let serverPort = self.portNumber
            let requestURL: URL = URL(string: "http://localhost:\(serverPort)\(path)")!
            let httpUrlResponse = HTTPURLResponse(url: requestURL, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type":"application/json"])!
            return LocalhostServerResponse(httpUrlResponse: httpUrlResponse, data: responseData)
        }
        return block
    }
    
    func responseData(filename: String) -> Data {
        guard let path = Bundle(for: MovieListTest.self).path(forResource: filename, ofType: "json", inDirectory: "Responses"),
            let data = try? NSData.init(contentsOfFile: path, options: []) else {
                fatalError("\(filename).json not found")
        }
        return data as Data
    }
}
