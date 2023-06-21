//
//  OfferCellViewModel.swift
//  ibotta
//
//  Created by Daniel Person on 6/21/23.
//

import Foundation

class OfferCellViewModel {
    
    let offer: Offer
    
    private var setCurrentValue: ((String) -> Void)? {
        didSet {
            setCurrentValue?(offer.currentValue)
        }
    }
    private var setName: ((String) -> Void)? {
        didSet {
            setName?(offer.name)
        }
    }
    
    init(offer: Offer) {
        self.offer = offer
    }
    
    func bindSetCurrentValue(_ setCurrentValue: @escaping ((String) -> Void)) {
        self.setCurrentValue = setCurrentValue
    }
    
    func bindSetName(_ setName: @escaping ((String) -> Void)) {
        self.setName = setName
    }
}
