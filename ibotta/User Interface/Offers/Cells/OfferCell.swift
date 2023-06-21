//
//  OfferCell.swift
//  ibotta
//
//  Created by Daniel Person on 6/9/23.
//

import ibottaUIKit

class OfferCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: OfferCellViewModel?
    
    // MARK: UI elements
    
    private var imageViewContainer: OfferCellImageContainer?
    private var image: UIImage? {
        didSet {
            /// Update on main thread
            DispatchQueue.main.async {
                self.imageViewContainer?.setImage(self.image)
            }
        }
    }
    
    private var currentValueLabel: OfferLabel?
    private var itemNameLabel: OfferLabel?
    
    // MARK: Constraints and constants for UI elements
    
    private let topLeadingConstant = 6.0
    private let bottomTrailingConstant = -6.0
        
    private lazy var imageViewContainerConstraints: [NSLayoutConstraint] = {
        guard let imageViewContainer = self.imageViewContainer, let currentValueLabel = self.currentValueLabel else {
            /// Something went very wrong
            return [NSLayoutConstraint]()
        }
        
        return [
            imageViewContainer.topAnchor.constraint(equalTo: self.topAnchor),
            imageViewContainer.bottomAnchor.constraint(equalTo: currentValueLabel.topAnchor, constant: -8.0),
            imageViewContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageViewContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
    }()
    
    private lazy var currentValueLabelConstraints: [NSLayoutConstraint] = {
        guard let currentValueLabel = self.currentValueLabel, let itemNameLabel = self.itemNameLabel else {
            /// Something went very wrong
            return [NSLayoutConstraint]()
        }
        
        return [
            currentValueLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            currentValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            currentValueLabel.bottomAnchor.constraint(equalTo: itemNameLabel.topAnchor, constant: -3.0),
            currentValueLabel.heightAnchor.constraint(equalToConstant: currentValueLabel.font.pointSize)
        ]
    }()
    
    private lazy var itemNameLabelConstraints: [NSLayoutConstraint] = {
        guard let itemNameLabel = self.itemNameLabel else {
            /// Something went very wrong
            return [NSLayoutConstraint]()
        }
        
        return [
            itemNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            itemNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            itemNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            itemNameLabel.heightAnchor.constraint(equalToConstant: itemNameLabel.font.pointSize)
        ]
    }()
    
    // MARK: Set up view elements
    
    /// Called on the collection view controller to set up the cell
    /// - Parameter offer: The `Offer` item cotaining the data for the cell
    func setupCell(withViewModel viewModel: OfferCellViewModel) {
        self.viewModel = viewModel
        
        setupItemNameLabelIfNeeded()
        viewModel.bindSetName { [weak self] text in
            self?.itemNameLabel?.text = text
        }
        
        setupCurrentValueLabelIfNeeded()
        viewModel.bindSetCurrentValue { [weak self] text in
            self?.currentValueLabel?.text = text
        }
        
        setupImageViewContainerIfNeeded()
        self.imageViewContainer?.setFavorite(ApplicationState.isFavorite(offer: viewModel.offer))
        
        getItemImage()
    }
    
    // MARK: First-time UI setup for new cells
    
    /// Since this cell can be reused, only initialize `imageViewContainer` if it doesn't already exist
    private func setupImageViewContainerIfNeeded() {
        if self.imageViewContainer == nil {
            self.imageViewContainer = ibottaUIKit.shared.offerCellImageContainer()
            self.addSubview(self.imageViewContainer!)
            NSLayoutConstraint.activate(imageViewContainerConstraints)
        }
    }
    
    /// Since this cell can be reused, only initialize `curentValueLabel` if it doesn't already exist
    private func setupCurrentValueLabelIfNeeded() {
        if self.currentValueLabel == nil {
            currentValueLabel = ibottaUIKit.shared.offerLabelWithStyle(.currentValueInCell)
            self.addSubview(currentValueLabel!)
            NSLayoutConstraint.activate(currentValueLabelConstraints)
        }
    }
    
    /// Since this cell can be reused, only initialize  `itemNameLabel` if it doesn't already exist
    private func setupItemNameLabelIfNeeded() {
        if self.itemNameLabel == nil {
            self.itemNameLabel = ibottaUIKit.shared.offerLabelWithStyle(.itemNameInCell)
            self.addSubview(itemNameLabel!)
            NSLayoutConstraint.activate(itemNameLabelConstraints)
        }
    }
    
    /// Sets the product image
    /// Initially sets the image to a placeholder
    /// Looks for a cached version of the image, otherwise retrieves from the image url
    private func getItemImage() {
        /// Set placeholder image
        self.image = ibottaUIKit.shared.offerPlaceholderImage()
        
        guard let url = self.viewModel?.offer.url else {
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
                self.image = ibottaUIKit.shared.offerPlaceholderImage()
                print("IMAGE ERROR: \(error)")
            }
        }
    }
}
