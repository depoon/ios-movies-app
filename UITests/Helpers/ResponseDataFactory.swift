//
//  ResponseDataFactory.swift
//  UITests
//
//  Created by Kenneth Poon on 22/12/18.
//  Copyright © 2018 Mohamed Elkamhawi. All rights reserved.
//

import Foundation

class ResponseDataFactory {
    static func responseData(filename: String) -> Data {
        guard let path = Bundle(for: ResponseDataFactory.self).path(forResource: filename, ofType: "json", inDirectory: "Responses"),
            let data = try? NSData.init(contentsOfFile: path, options: []) else {
                fatalError("\(filename).json not found")
        }
        return data as Data
    }
}
