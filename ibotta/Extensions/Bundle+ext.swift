//
//  Bundle+ext.swift
//  ibotta
//
//  Created by Daniel Person on 6/9/23.
//

import Foundation

extension Bundle {
    
    static func dataFromJsonFile(_ name: String) throws -> Data {
        var json: Data
        
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                json = jsonData
            } else {
                throw NSError(domain: "BundleErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not find json resource: \(name)"])
            }
        } catch {
            throw error
        }
        
        return json
    }
}
