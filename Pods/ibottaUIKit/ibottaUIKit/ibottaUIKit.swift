//
//  ibottaUIKit.swift
//  ibottaUIKit
//
//  Created by Daniel Person on 6/20/23.
//

import Foundation
import UIKit

public struct ibottaUIKitSettings {
    
    /// The base name for the system font
    /// i.e. "AvenirNext" for fonts like "AvenirNext-DemiBold"
    let fontBaseName: String
    /// The main font color for the titles and descriptions
    let fontColor: UIColor
    /// Placeholder image
    let placeholderImage: UIImage
    
    public init(fontBaseName: String, fontColor: UIColor, placeHolderImage: UIImage) {
        self.fontBaseName = fontBaseName
        self.fontColor = fontColor
        self.placeholderImage = placeHolderImage
    }
}

public final class ibottaUIKit {
    
    var fontBaseName: String
    var fontColor: UIColor
    var placeholderImage: UIImage
    
    /// Required settings
    public static var settings: ibottaUIKitSettings?
    
    /// Shared instance
    public static var shared: ibottaUIKit = {
        guard let settings = ibottaUIKit.settings else {
            fatalError("ibottaUIKit settings not set")
        }
        return ibottaUIKit(withSettings: settings)
    }()
    
    private init(withSettings settings: ibottaUIKitSettings) {
        self.fontBaseName = settings.fontBaseName
        self.fontColor = settings.fontColor
        self.placeholderImage = settings.placeholderImage
    }
    
    public func offerPlaceholderImage() -> UIImage {
        return self.placeholderImage
    }
        
    public func offerLabelWithStyle(_ style: ibottaLabelStyle) -> OfferLabel {
        let label = OfferLabel()
        label.setup(withStyle: style)
        
        return label
    }
    
    public func offerCellImageContainer() -> OfferCellImageContainer {
        let view = OfferCellImageContainer()
        view.setup()
        
        return view
    }
    
    public func offerDetailImageContainer(withFavoriteAction favoriteAction: @escaping (() -> Void)) -> OfferDetailImageContainer {
        let view = OfferDetailImageContainer()
        view.setup(withFavoriteAction: favoriteAction)
        
        return view
    }
}
