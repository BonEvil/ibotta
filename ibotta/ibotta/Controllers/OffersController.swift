//
//  OffersController.swift
//  ibotta
//
//  Created by Daniel Person on 6/9/23.
//

import Foundation
import BuckarooBanzai

struct OffersController {
    
    static func retrieveOffers() async throws -> [Offer] {
        do {
            let response = try await BuckarooBanzai.shared.start(service: OffersService())
            let offers: [Offer] = try response.decodeBodyData(convertFromSnakeCase: true)
            return offers
        } catch {
            throw error
        }
    }
}
