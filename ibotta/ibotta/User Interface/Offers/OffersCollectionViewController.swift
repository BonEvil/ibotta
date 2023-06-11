//
//  OffersCollectionViewController.swift
//  ibotta
//
//  Created by Daniel Person on 6/9/23.
//

import UIKit

class OffersCollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "offercell"
    
    var offers: [Offer]? {
        didSet {
            self.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(OfferCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.title = "Offers"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.retrieveOffers()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let offers = self.offers else {
            return 0
        }
        
        return offers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? OfferCell, let offers = self.offers else {
            /// Something went really wrong
            /// This should not happen otherwise
            fatalError("unable to create cell")
        }
        cell.setupCell(forOffer: offers[indexPath.row])
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedOffer = offers?[indexPath.row] else {
            return
        }
        let offerDetailViewController = OfferDetailViewController()
        offerDetailViewController.offer = selectedOffer
        
        self.navigationController?.pushViewController(offerDetailViewController, animated: true)
    }
}

extension OffersCollectionViewController {
    
    /// Calls the `OffersController.retrieveOffers` method to get the offers JsON
    private func retrieveOffers() {
        
        /// Check for cached offers first
        if let offers = ApplicationState.offers {
            self.offers = offers
            return
        }
        
        Task {
            do {
                let offers = try await OffersController.retrieveOffers()
                ApplicationState.offers = offers
                self.offers = offers
            } catch {
                // TODO: Inform the user of an error
                print("OFFERS ERROR: \(error)")
            }
        }
    }
}

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
