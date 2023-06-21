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
        
    private static var favorites: Set<Offer> = Set<Offer>()
    
    static func isFavorite(offer: Offer?) -> Bool {
        guard let offer = offer else { return false }
        
        return favorites.contains(offer)
    }
    
    static func addFavorite(offer: Offer?) {
        if let offer = offer {
            favorites.insert(offer)
        }
    }
    
    static func removeFavorite(offer: Offer?) {
        if let offer = offer {
            favorites.remove(offer)
        }
    }
    
    // MARK: - Images
    
    static let queue = DispatchQueue(label: "thread-safe-array")
    
    /// Simple image cache to limit network calls
    private static var imageCache: [ImageItem] = [ImageItem]() {
        didSet {
            /// Arbitrary cache limit on images
            /// Can be modified to check for remaining disk space etc.
            if imageCache.count > 50 && imageCache.first != nil {
                imageCache.remove(at: 0)
            }
        }
    }
    
    static func addCachedImage(forItem imageItem: ImageItem) {
        if cachedImage(fromUrl: imageItem.url) != nil {
            return
        }
        queue.async {
            imageCache.append(imageItem)
        }
    }
    
    static func cachedImage(fromUrl url: String) -> UIImage? {
        queue.sync {
            if let imageItem = imageCache.first(where: { item in
                item.url == url
            }) {
                return imageItem.image
            }
            
            return nil
        }
    }
    
    static func clearCachedImages() {
        imageCache.removeAll()
    }
}
