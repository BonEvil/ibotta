//
//  OffersController.swift
//  ibotta
//
//  Created by Daniel Person on 6/9/23.
//

import Foundation
import BuckarooBanzai

struct OffersController {
    
    /// Method to asynchronously retrieve the offers data from a service
    /// - Returns: An array of `Offer` items
    static func retrieveOffers() async throws -> [Offer] {
        do {
            let response = try await BuckarooBanzai.shared.start(service: OffersService())
            let offers: [Offer] = try response.decodeBodyData(convertFromSnakeCase: true)
            return offers
        } catch {
            throw error
        }
    }
    
    /// Method to asynchronously retrieve an image from the specified url
    /// - Parameter url: The full URL to the image
    /// - Returns: A `UIImage` object if the returned data can be decoded to an image
    static func retrieveImage(_ url: String) async throws -> UIImage {
        do {
            let service = ImageService(withImageUrl: url)
            let response = try await BuckarooBanzai.shared.start(service: service)
            let image = try response.decodeBodyDataAsImage()
            
            ApplicationState.addCachedImage(forItem: ImageItem(url: url, image: image))
            return image
        } catch {
            throw error
        }
    }
}
