//
//  CollectionViewController.swift
//  ibotta
//
//  Created by Daniel Person on 6/9/23.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
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
        self.retrieveOffers()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

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
            fatalError("unable to create cell")
        }
        cell.setupCell(forOffer: offers[indexPath.row])
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DID SELECT: \(indexPath)")
    }
}

extension CollectionViewController {
    
    private func retrieveOffers() {
        Task {
            do {
                let offers = try await OffersController.retrieveOffers()
                self.offers = offers
            } catch {
                print("OFFERS ERROR: \(error)")
            }
        }
    }
    
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
