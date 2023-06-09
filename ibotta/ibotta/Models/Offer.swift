//
//  Offer.swift
//  ibotta
//
//  Created by Daniel Person on 6/9/23.
//

import Foundation

struct Offer: Codable {
    let id: String
    let url: String?
    let name: String
    let description: String
    let terms: String
    let currentValue: String    
}
