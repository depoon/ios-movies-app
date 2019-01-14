//
//  ProcessInfo+PortNumber.swift
//  ios-movies-app
//
//  Created by Kenneth Poon on 27/12/18.
//  Copyright © 2018 Mohamed Elkamhawi. All rights reserved.
//

import Foundation

extension ProcessInfo {
    static func infoValue(for key: String) -> String? {
        let arguments = self.processInfo.arguments
        let filtered = arguments.filter {
            return $0.hasPrefix("\(key):")
        }
        guard let argument = filtered.first else {
            return nil
        }
        let values = argument.split(separator: ":")
        guard values.count > 0 else {
            return nil
        }
        return String(values[1])
    }

}
