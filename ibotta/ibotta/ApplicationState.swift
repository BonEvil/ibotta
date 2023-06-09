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
    
    /// Ephemeral state for favorites
    static var favorites: [Offer] = [Offer]()
    
    /// Simple image cache to limit network calls
    static var imageCache: [ImageItem] = [ImageItem]() {
        didSet {
            /// Arbitrary cache limit on images
            /// Can be modified to check for remaining disk space etc.
            if imageCache.count > 50, imageCache.first != nil {
                imageCache.remove(at: 0)
            }
        }
    }
}
