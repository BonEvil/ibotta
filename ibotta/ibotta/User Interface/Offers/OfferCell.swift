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
    
    /// Used to ensure all image operations are in background thread; setting the image is done on the main thread
    private let queue = DispatchQueue(label: "imageQueue")
    
    private let nameLabelFontSize = 11.0
    private let currentValueLabelFontSize = 12.0
    private lazy var wH: CGFloat = {
        return (self.frame.width / 5)
    }()
    
    // MARK: View elements
    
    private var imageViewContainer: UIView?
    private var imageView: UIImageView?
    private var image: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.imageView?.image = self.image
            }
        }
    }
    
    private var currentValueLabel: UILabel?
    private var itemNameLabel: UILabel?
    private var favoriteImageView: UIImageView?
    
    // MARK: UI element constraints
    
    private lazy var imageViewContainerConstraints: [NSLayoutConstraint] = {
        guard let imageViewContainer = self.imageViewContainer, let currentValueLabel = self.currentValueLabel else {
            return [NSLayoutConstraint]()
        }
        
        return [
            imageViewContainer.topAnchor.constraint(equalTo: self.topAnchor),
            imageViewContainer.bottomAnchor.constraint(equalTo: currentValueLabel.topAnchor, constant: -8.0),
            imageViewContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageViewContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
    }()
    
    private lazy var imageViewConstraints: [NSLayoutConstraint] = {
        guard let imageViewContainer = self.imageViewContainer, let imageView = self.imageView else {
            return [NSLayoutConstraint]()
        }
        
        return [
            imageView.topAnchor.constraint(equalTo: imageViewContainer.topAnchor, constant: 6.0),
            imageView.bottomAnchor.constraint(equalTo: imageViewContainer.bottomAnchor, constant: -6.0),
            imageView.leadingAnchor.constraint(equalTo: imageViewContainer.leadingAnchor, constant: 6.0),
            imageView.trailingAnchor.constraint(equalTo: imageViewContainer.trailingAnchor, constant: -6.0)
        ]
    }()
    
    private lazy var currentValueLabelConstraints: [NSLayoutConstraint] = {
        guard let currentValueLabel = self.currentValueLabel, let itemNameLabel = self.itemNameLabel else {
            return [NSLayoutConstraint]()
        }
        
        return [
            currentValueLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            currentValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            currentValueLabel.bottomAnchor.constraint(equalTo: itemNameLabel.topAnchor, constant: -3.0),
            currentValueLabel.heightAnchor.constraint(equalToConstant: currentValueLabelFontSize + 1)
        ]
    }()
    
    private lazy var itemNameLabelConstraints: [NSLayoutConstraint] = {
        guard let itemNameLabel = self.itemNameLabel else {
            return [NSLayoutConstraint]()
        }
        
        return [
            itemNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            itemNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            itemNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            itemNameLabel.heightAnchor.constraint(equalToConstant: nameLabelFontSize + 1) // Extra height for hanging characters
        ]
    }()
    
    private lazy var favoriteImageViewConstraints: [NSLayoutConstraint] = {
        guard let favoriteImageView = self.favoriteImageView else {
            return [NSLayoutConstraint]()
        }

        return [
            favoriteImageView.heightAnchor.constraint(equalToConstant: wH),
            favoriteImageView.widthAnchor.constraint(equalToConstant: wH),
            favoriteImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6.0),
            favoriteImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -6.0)
        ]
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
        
        checkIsFavorite()
    }
    
    func checkIsFavorite() {
        if ApplicationState.isFavorite(offer: self.offer) {
            setupFavoriteImageIfNeeded()
        } else {
            favoriteImageView?.removeFromSuperview()
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
        
        guard let offer = self.offer, let url = offer.url else {
            return
        }
        
        /// Check for cached image
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
    
    // MARK: First-time UI setup for new cells
    
    /// Since this cell can be reused, only initialize `imageViewContainer` if it doesn't already exist
    private func setupImageViewContainerIfNeeded() {
        if self.imageViewContainer == nil {
            self.imageViewContainer = UIView()
            
            guard let imageViewContainer = self.imageViewContainer else {
                return
            }
            
            imageViewContainer.backgroundColor = UIColor.init(white: 0.0, alpha: 0.2)
            imageViewContainer.layer.cornerRadius = 5.0
            addSubview(imageViewContainer)
            
            imageViewContainer.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(imageViewContainerConstraints)
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
            NSLayoutConstraint.activate(imageViewConstraints)
        }
    }
    
    /// Since this cell can be reused, only initialize `curentValueLabel` if it doesn't already exist
    private func setupCurrentValueLabelIfNeeded() {
        if self.currentValueLabel == nil {
            self.currentValueLabel = UILabel()
            
            guard let currentValueLabel = self.currentValueLabel else {
                return
            }
            
            currentValueLabel.numberOfLines = 1
            currentValueLabel.font = UIFont(name: Fonts.demiBold, size: currentValueLabelFontSize)
            currentValueLabel.textColor = FontColors.main
            
            self.addSubview(currentValueLabel)
            
            currentValueLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(currentValueLabelConstraints)
        }
    }
    
    /// Since this cell can be reused, only initialize  `itemNameLabel` if it doesn't already exist
    private func setupItemNameLabelIfNeeded() {
        if self.itemNameLabel == nil {
            self.itemNameLabel = UILabel()
            
            guard let itemNameLabel = self.itemNameLabel else {
                return
            }
            
            itemNameLabel.numberOfLines = 1
            itemNameLabel.font = UIFont(name: Fonts.regular, size: nameLabelFontSize)
            itemNameLabel.textColor = FontColors.main
            
            self.addSubview(itemNameLabel)
            
            itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(itemNameLabelConstraints)
        }
    }
    
    private func setupFavoriteImageIfNeeded() {
        if self.favoriteImageView == nil {
            self.favoriteImageView = UIImageView()
        }
        
        guard let favoriteImageView = self.favoriteImageView else {
            return
        }
        
        favoriteImageView.tintColor = .systemYellow
        favoriteImageView.image = UIImage(systemName: Images.favoriteTrue)
        favoriteImageView.backgroundColor = .white
        favoriteImageView.layer.cornerRadius = wH / 2
        
        self.addSubview(favoriteImageView)
        
        favoriteImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(favoriteImageViewConstraints)
    }
}
