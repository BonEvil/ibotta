//
//  OfferLabel.swift
//  ibottaUIKit
//
//  Created by Daniel Person on 6/20/23.
//

import UIKit

public enum ibottaLabelStyle {
    case currentValueInCell
    case itemNameInCell
    case itemNameInDetail
    case descriptionInDetail
    case termsInDetail
}

public class OfferLabel: UILabel {
    
    enum FontSuffix: String {
        case regular = "-Regular"
        case demiBold = "-DemiBold"
    }

    func setup(withStyle style: ibottaLabelStyle) {
        var fontSuffix = FontSuffix.regular
        var fontSize = 0.0
        var numberOfLines = 0
        
        switch style {
        case .currentValueInCell:
            fontSuffix = .demiBold
            fontSize = 12.0
            numberOfLines = 1
        case .itemNameInCell:
            fontSize = 11.0
            numberOfLines = 1
        case .itemNameInDetail:
            fontSuffix = .demiBold
            fontSize = 18.0
            self.textAlignment = .center
        case .descriptionInDetail:
            fontSuffix = .demiBold
            fontSize = 12.0
        case .termsInDetail:
            fontSize = 11.0
        }
        
        self.numberOfLines = numberOfLines
        self.font = UIFont(name: ibottaUIKit.shared.fontBaseName + fontSuffix.rawValue, size: fontSize)
        self.textColor = ibottaUIKit.shared.fontColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
