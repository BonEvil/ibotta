//
//  OfferDetailViewModel.swift
//  ibotta
//
//  Created by Daniel Person on 6/21/23.
//

import Foundation

class OfferDetailViewModel {
    
    let offer: Offer
    
    init(offer: Offer) {
        self.offer = offer
    }
    
    private var setName: ((String) -> Void)? {
        didSet {
            setName?(offer.name)
        }
    }
    private var setDescription: ((String) -> Void)? {
        didSet {
            setDescription?(offer.description)
        }
    }
    private var setTerms: ((String) -> Void)? {
        didSet {
            setTerms?(offer.terms)
        }
    }
    private var setFavorite: ((Bool) -> Void)? {
        didSet {
            setFavorite?(ApplicationState.isFavorite(offer: offer))
        }
    }
    
    func bindSetName(_ setName: @escaping  ((String) -> Void)) {
        self.setName = setName
    }
    
    func bindSetDescription(_ setDescription: @escaping ((String) -> Void)) {
        self.setDescription = setDescription
    }
    
    func bindSetTerms(_ setTerms: @escaping  ((String) -> Void)) {
        self.setTerms = setTerms
    }
    
    func bindSetFavorite(_ setFavorite: @escaping ((Bool) -> Void)) {
        self.setFavorite = setFavorite
    }
    
    @objc
    func toggleFavorite() {
        if ApplicationState.isFavorite(offer: offer) {
            ApplicationState.removeFavorite(offer: offer)
        } else {
            ApplicationState.addFavorite(offer: offer)
        }
        
        self.setFavorite?(ApplicationState.isFavorite(offer: offer))
    }
    
    
}
