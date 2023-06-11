//
//  ApplicationState.swift
//  ibotta
//
//  Created by Daniel Person on 6/9/23.
//

import Foundation
import UIKit

/// Can be modified to persist
struct ApplicationState {
    
    // MARK: - Offers
    
    static var offers: [Offer]?
    
    // MARK: - Favorites
    
    private static var favorites: [Offer] = [Offer]()
    
    static func isFavorite(offer: Offer?) -> Bool {
        if let offer = offer, favorites.contains(where: { favOffer in
            favOffer.id == offer.id
        }) {
            return true
        }
        
        return false
    }
    
    static func addFavorite(offer: Offer?) {
        if let offer = offer, !isFavorite(offer: offer) {
            favorites.append(offer)
        }
    }
    
    static func removeFavorite(offer: Offer?) {
        if let offer = offer, isFavorite(offer: offer) {
            favorites.removeAll { favOffer in
                favOffer.id == offer.id
            }
        }
    }
    
    // MARK: - Images
    
    /// Simple image cache to limit network calls
    private static var imageCache: [ImageItem] = [ImageItem]() {
        didSet {
            /// Arbitrary cache limit on images
            /// Can be modified to check for remaining disk space etc.
            if imageCache.count > 50, imageCache.first != nil {
                imageCache.remove(at: 0)
            }
        }
    }
    
    static func addCachedImage(forItem imageItem: ImageItem) {
        imageCache.append(imageItem)
    }
    
    static func cachedImage(fromUrl url: String) -> UIImage? {
        if let imageItem = imageCache.first(where: { item in
            item.url == url
        }) {
            return imageItem.image
        }
        
        return nil
    }
    
    static func clearCachedImages() {
        imageCache.removeAll()
    }
}
