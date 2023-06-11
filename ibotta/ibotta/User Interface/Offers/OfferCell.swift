//
//  OfferCell.swift
//  ibotta
//
//  Created by Daniel Person on 6/9/23.
//

import UIKit

class OfferCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var offer: Offer?
    
    /// Instance of a `UIImage` to use as a placeholder for all cells
    private let placeholderImage = UIImage(named: Images.placeholder)
    private let queue = DispatchQueue(label: "imageQueue")
    
    // MARK: View elements
    
    /// Container for the `imageView`
    private var imageViewContainer: UIView?
    
    /// The product image view
    var imageView: UIImageView?
    var image: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.imageView?.image = self.image
            }
        }
    }
    
    private var currentValueLabel: UILabel?
    private var itemNameLabel: UILabel?
    
    // MARK: Constraint graphs and constants reference
    
    let nameLabelFontSize = 11.0
    let currentValueLabelFontSize = 12.0
    
    private lazy var nameLabelConstraintGraph: ConstraintGraph = {
        return ConstraintGraph(height: nameLabelFontSize + 1) // Extra height for hanging characters
    }()
    
    private lazy var currentValueConstrainGraph: ConstraintGraph = {
        return ConstraintGraph(height: currentValueLabelFontSize + 1, bottomAnchor: -3.0) // Extra height for hanging characters
    }()
    
    private lazy var imageViewContainerConstraintGraph: ConstraintGraph = {
        return ConstraintGraph(bottomAnchor: -8.0)
    }()
    
    private lazy var imageViewConstraintGraph: ConstraintGraph = {
        return ConstraintGraph(leadingAnchor: 6.0, topAnchor: 6.0, trailingAnchor: -6.0, bottomAnchor: -6.0)
    }()
    
    // MARK: Set up view elements
    
    /// Called on the collection view controller to set up the cell
    /// - Parameter offer: The `Offer` item cotaining the data for the cell
    func setupCell(forOffer offer: Offer) {
        self.offer = offer

        setupItemNameLabelIfNeeded()
        setupCurrentValueLabelIfNeeded()
        setItemText()
        
        setupImageViewContainerIfNeeded()
        setupImageViewIfNeeded()
        queue.async {
            self.setItemImage()
        }
    }
    
    /// Sets the text for the product name and the current value
    private func setItemText() {
        self.itemNameLabel?.text = offer?.name
        self.currentValueLabel?.text = offer?.currentValue
    }
    
    /// Sets the product image
    /// Initially sets the image to a placeholder
    /// Looks for a cached version of the image, otherwise retrieves from the image url
    private func setItemImage() {
        /// Set placeholder image
        self.image = placeholderImage
        
        /// Check for cached image
        guard let offer = self.offer, let url = offer.url else {
            return
        }
        if let image = ApplicationState.cachedImage(fromUrl: url) {
            self.image = image
            return
        }
        
        /// Retrieve image from URL
        Task {
            do {
                let image = try await OffersController.retrieveImage(url)
                self.image = image
            } catch {
                print("IMAGE ERROR: \(error)")
            }
        }
    }
    
    // MARK: Firt-time UI setup for new cells
    
    /// Since this cell can be reused, only initialize  `itemNameLabel` if it doesn't already exist
    private func setupItemNameLabelIfNeeded() {
        if self.itemNameLabel == nil {
            self.itemNameLabel = UILabel()
            
            guard let itemNameLabel = self.itemNameLabel else {
                return
            }
            
            itemNameLabel.numberOfLines = 1
            itemNameLabel.font = UIFont(name: Fonts.regular, size: nameLabelFontSize)
            itemNameLabel.textColor = UIColor(named: Fonts.fontColor)
            
            self.addSubview(itemNameLabel)
            
            itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                itemNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                itemNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                itemNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                itemNameLabel.heightAnchor.constraint(equalToConstant: nameLabelConstraintGraph.height) /// Give enough room for hanging letters so they don't get cut off
            ])
        }
    }
    
    /// Since this cell can be reused, only initialize `curentValueLabel` if it doesn't already exist
    private func setupCurrentValueLabelIfNeeded() {
        if self.currentValueLabel == nil {
            self.currentValueLabel = UILabel()
            
            guard let currentValueLabel = self.currentValueLabel, let itemNameLabel = self.itemNameLabel else {
                return
            }
            
            currentValueLabel.numberOfLines = 1
            currentValueLabel.font = UIFont(name: Fonts.demiBold, size: currentValueLabelFontSize)
            currentValueLabel.textColor = UIColor(named: Fonts.fontColor)
            
            self.addSubview(currentValueLabel)
            
            currentValueLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                currentValueLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                currentValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                currentValueLabel.bottomAnchor.constraint(equalTo: itemNameLabel.topAnchor, constant: currentValueConstrainGraph.bottomAnchor),
                currentValueLabel.heightAnchor.constraint(equalToConstant: currentValueConstrainGraph.height)
            ])
        }
    }
    
    /// Since this cell can be reused, only initialize `imageViewContainer` if it doesn't already exist
    private func setupImageViewContainerIfNeeded() {
        if self.imageViewContainer == nil {
            self.imageViewContainer = UIView()
            
            guard let imageViewContainer = self.imageViewContainer, let currentValueLabel = self.currentValueLabel else {
                return
            }
            
            imageViewContainer.backgroundColor = UIColor.init(white: 0.0, alpha: 0.2)
            imageViewContainer.layer.cornerRadius = 5.0
            addSubview(imageViewContainer)
            
            imageViewContainer.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageViewContainer.topAnchor.constraint(equalTo: self.topAnchor),
                imageViewContainer.bottomAnchor.constraint(equalTo: currentValueLabel.topAnchor, constant: imageViewContainerConstraintGraph.bottomAnchor),
                imageViewContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                imageViewContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        }
    }
    
    /// Since this cell can be reused, only initialize `imageView` if it doesn't already exist
    private func setupImageViewIfNeeded() {
        if self.imageView == nil {
            self.imageView = UIImageView()
            
            guard let imageViewContainer = self.imageViewContainer, let imageView = self.imageView else {
                return
            }
            
            imageView.contentMode = .scaleAspectFit
            imageViewContainer.addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: imageViewContainer.topAnchor, constant: imageViewConstraintGraph.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: imageViewContainer.bottomAnchor, constant: imageViewConstraintGraph.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: imageViewContainer.leadingAnchor, constant: imageViewConstraintGraph.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: imageViewContainer.trailingAnchor, constant: imageViewConstraintGraph.trailingAnchor)
            ])
        }
    }
}
