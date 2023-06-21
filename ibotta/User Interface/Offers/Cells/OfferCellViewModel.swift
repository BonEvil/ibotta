//
//  OfferCellViewModel.swift
//  ibotta
//
//  Created by Daniel Person on 6/21/23.
//

import Foundation
import UIKit /// Normally I wouldn't want UIKit in a view model but this is really the only functionality for the cell

class OfferCellViewModel {
    
    /// Instance of a `UIImage` to use as a placeholder for all cells
    private let placeholderImage = UIImage(named: "ImageNotAvailable")
    
    var offer: Offer
    
    private var setImage: ((UIImage) -> Void)?
    
    init(offer: Offer) {
        self.offer = offer
    }
    
    func bindImage(_ setImage: @escaping ((UIImage) -> Void)) {
        self.setImage = setImage
        getItemImage()
    }
    
    /// Sets the product image
    /// Initially sets the image to a placeholder
    /// Looks for a cached version of the image, otherwise retrieves from the image url
    private func getItemImage() {
        /// Set placeholder image
        if let placeholderImage = self.placeholderImage {
            setImage?(placeholderImage)
        }
        
        guard let url = self.offer.url else {
            return
        }
        
        /// Check for cached image
        if let image = ApplicationState.cachedImage(fromUrl: url) {
            setImage?(image)
            return
        }
        
        /// Retrieve image from URL
        Task {
            do {
                let image = try await OffersController.retrieveImage(url)
                setImage?(image)
            } catch {
                print("IMAGE ERROR: \(error)")
            }
        }
    }
}
