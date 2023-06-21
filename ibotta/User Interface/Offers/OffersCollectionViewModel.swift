//
//  OffersCollectionViewModel.swift
//  ibotta
//
//  Created by Daniel Person on 6/20/23.
//

import Foundation

class OffersCollectionViewModel {
    
    let title = "Offers"
    
    var setOffers: (([Offer]) -> Void)?
    
    func bindSetOffers(_ setOffers: @escaping (([Offer]) -> Void)) {
        self.setOffers = setOffers
        
        retrieveOffers()
    }
    
    func retrieveOffers() {
        /// Check for cached offers first
        if let offers = ApplicationState.offers {
            setOffers?(offers)
            return
        }
        
        Task {
            do {
                let offers = try await OffersController.retrieveOffers()
                ApplicationState.offers = offers
                /// This was in the background, do update on main thread
                DispatchQueue.main.async { [weak self] in
                    self?.setOffers?(offers)
                }
            } catch {
                // TODO: Inform the user of an error
                print("OFFERS ERROR: \(error)")
            }
        }
    }
}
