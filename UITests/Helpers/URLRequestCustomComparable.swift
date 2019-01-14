//
//  URLRequestCustomComparable.swift
//  UITests
//
//  Created by Kenneth Poon on 1/1/19.
//  Copyright © 2019 Mohamed Elkamhawi. All rights reserved.
//

import Foundation

struct URLRequestCustomComparable {
    let httpMethod: String
    let path: String
    let query: String
    let body: String
}

extension URLRequestCustomComparable: Equatable {
    static func == (lhs: URLRequestCustomComparable, rhs: URLRequestCustomComparable) -> Bool {
        guard lhs.httpMethod == rhs.httpMethod else { return false }
        guard lhs.path == rhs.path else { return false }
        guard lhs.query == rhs.query else { return false }
        guard lhs.body == rhs.body else { return false }
        return true
    }
}

extension URLRequest {
    func customComparable() -> URLRequestCustomComparable {
        var requestMethod = "GET"
        if let httpMethod = self.httpMethod {
            requestMethod = httpMethod
        }
        let path = self.url!.path
        var query = ""
        if let aQuery = self.url?.query {
            query = aQuery
        }
        var body = ""
        if let contentType = self.allHTTPHeaderFields?["Content-Type"], contentType == "application/json" {
            if let dataBody = self.httpBody, let stringBody = String(data: dataBody, encoding: String.Encoding.utf8) {
                body = stringBody
            }
        }
        return URLRequestCustomComparable(httpMethod: requestMethod,
                                   path: path,
                                   query: query,
                                   body: body)
    }
}
