//
//  OfferCell.swift
//  ibotta
//
//  Created by Daniel Person on 6/9/23.
//

import UIKit
import BuckarooBanzai

class OfferCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let placeholderImage = UIImage(systemName: "carrot")
    private var imageViewContainer: UIView? {
        didSet {
            imageViewContainer?.backgroundColor = UIColor.init(white: 0.0, alpha: 0.2)
            imageViewContainer?.layer.cornerRadius = 5.0
        }
    }
    private var imageView: UIImageView? {
        didSet {
            imageView?.contentMode = .scaleAspectFit
        }
    }
    private var currentValueLabel: UILabel?
    private var itemNameLabel: UILabel?
    
    private var offer: Offer?
    
    func setupCell(forOffer offer: Offer) {
        self.offer = offer

        setupItemNameLabelIfNeeded()
        setupItemOfferLabelIfNeeded()
        setItemText()
        
        setupImageViewContainerIfNeeded()
        setupImageViewIfNeeded()
        setItemImage()
    }
    
    private func setItemText() {
        self.itemNameLabel?.text = offer?.name
        self.currentValueLabel?.text = offer?.currentValue
    }
    
    private func setItemImage() {
        /// Set placeholder image
        self.imageView?.image = placeholderImage
        guard let offer = self.offer, let url = offer.url else {
            return
        }
        
        /// Check for cached image first
        if let imageItem = ApplicationState.imageCache.first(where: { item in
            item.url == url
        }) {
            self.imageView?.image = imageItem.image
            return
        }
        
        Task {
            do {
                let service = ImageService(withImageUrl: url)
                let response = try await BuckarooBanzai.shared.start(service: service)
                let image = try response.decodeBodyDataAsImage()
                self.imageView?.image = image
                ApplicationState.imageCache.append(ImageItem(url: url, image: image))
            } catch {
                print("IMAGE ERROR: \(error)")
            }
        }
    }
    
    private func setupItemNameLabelIfNeeded() {
        if self.itemNameLabel == nil {
            self.itemNameLabel = UILabel()
            self.itemNameLabel?.numberOfLines = 1
            self.itemNameLabel?.font = UIFont(name: "AvenirNext-Regular", size: 11.0)
            self.itemNameLabel?.textColor = UIColor(named: "FontColor")
            
            self.addSubview(itemNameLabel!)
            
            self.itemNameLabel?.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                itemNameLabel!.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                itemNameLabel!.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                itemNameLabel!.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                itemNameLabel!.heightAnchor.constraint(equalToConstant: 12.0) /// Give enough room for hanging letters so they don't get cut off
            ])
        }
    }
    
    private func setupItemOfferLabelIfNeeded() {
        if self.currentValueLabel == nil {
            self.currentValueLabel = UILabel()
            self.currentValueLabel?.numberOfLines = 1
            self.currentValueLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 12.0)
            self.currentValueLabel?.textColor = UIColor(named: "FontColor")
            
            self.addSubview(currentValueLabel!)
            
            self.currentValueLabel?.translatesAutoresizingMaskIntoConstraints = false
            
            guard let itemNameLabel = self.itemNameLabel else {
                return
            }
            NSLayoutConstraint.activate([
                currentValueLabel!.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                currentValueLabel!.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                currentValueLabel!.bottomAnchor.constraint(equalTo: itemNameLabel.topAnchor, constant: -3.0),
                currentValueLabel!.heightAnchor.constraint(equalToConstant: 13.0) /// Give enough room for hanging letters so they don't get cut off
            ])
        }
    }
    
    private func setupImageViewContainerIfNeeded() {
        if imageViewContainer == nil {
            self.imageViewContainer = UIView()
            addSubview(imageViewContainer!)
            
            self.imageViewContainer?.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageViewContainer!.topAnchor.constraint(equalTo: self.topAnchor),
                imageViewContainer!.bottomAnchor.constraint(equalTo: currentValueLabel!.topAnchor, constant: -8.0),
                imageViewContainer!.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                imageViewContainer!.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        }
    }
    
    private func setupImageViewIfNeeded() {
        if imageView == nil {
            self.imageView = UIImageView()
            self.imageView?.tintColor = .orange
            imageViewContainer?.addSubview(imageView!)
            
            self.imageView?.translatesAutoresizingMaskIntoConstraints = false
            
            guard let imageViewContainer = self.imageViewContainer else {
                return
            }
            NSLayoutConstraint.activate([
                imageView!.topAnchor.constraint(equalTo: imageViewContainer.topAnchor, constant: 6.0),
                imageView!.bottomAnchor.constraint(equalTo: imageViewContainer.bottomAnchor, constant: -6.0),
                imageView!.leadingAnchor.constraint(equalTo: imageViewContainer.leadingAnchor, constant: 6.0),
                imageView!.trailingAnchor.constraint(equalTo: imageViewContainer.trailingAnchor, constant: -6.0)
            ])
        }
    }
}
