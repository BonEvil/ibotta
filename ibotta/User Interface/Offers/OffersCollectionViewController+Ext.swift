//
//  OffersCollectionViewController+Ext.swift
//  ibotta
//
//  Created by Daniel Person on 6/20/23.
//

import UIKit

extension OffersCollectionViewController {
    
    /// Layout for the collection view to encapsulate the definition in the mock image and documentation
    /// - Parameter bounds: the frame size of the container
    /// - Returns: a `UICollectionViewLayout` to style the collection view
    static func collectionViewControllerLayout(withBounds bounds: CGRect) -> UICollectionViewLayout {
        let left = 12.0
        let right = 12.0
        let itemSpace = 8.0
        let viewBorder = 2.0
        let itemWidth = ((bounds.width - (left + right + itemSpace + viewBorder)) / 2)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: left, bottom: 20, right: right)
        layout.minimumLineSpacing = 24
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 0.9)
        layout.scrollDirection = .vertical
        
        return layout
    }
}
