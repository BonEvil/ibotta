//
//  OffersCollectionViewController.swift
//  ibotta
//
//  Created by Daniel Person on 6/9/23.
//

import UIKit

class OffersCollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "offercell"
    
    let offersCollectionViewModel = OffersCollectionViewModel()
    
    var offers: [Offer]? {
        didSet {
            self.collectionView.reloadData()
        }
    }

    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = offersCollectionViewModel.title
        self.offersCollectionViewModel.bindOffers { [weak self] offers in
            self?.offers = offers
        }
        
        collectionView.register(OfferCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = UIColor(named: "BackgroundColor")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.offersCollectionViewModel.retrieveOffers()
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
        cell.setupCell(withViewModel: OfferCellViewModel(offer: offers[indexPath.row]))
    
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
