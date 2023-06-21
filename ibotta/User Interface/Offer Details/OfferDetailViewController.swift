//
//  OfferDetailViewController.swift
//  ibotta
//
//  Created by Daniel Person on 6/10/23.
//

import ibottaUIKit

class OfferDetailViewController: UIViewController {
    
    var viewModel: OfferDetailViewModel? {
        didSet {
            self.title = viewModel?.offer.currentValue
        }
    }
    
    // MARK: UI elements

    private var offerDetailImageContainer: OfferDetailImageContainer? {
        didSet {
            if let offerDetailImageContainer = self.offerDetailImageContainer {
                self.view.addSubview(offerDetailImageContainer)
                NSLayoutConstraint.activate(imageViewContainerConstraints)
            }
        }
    }
    private var nameLabel: OfferLabel? {
        didSet {
            if let nameLabel = self.nameLabel {
                self.view.addSubview(nameLabel)
                NSLayoutConstraint.activate(nameLabelConstraints)
            }
        }
    }
    private var descriptionLabel: OfferLabel? {
        didSet {
            if let descriptionLabel = self.descriptionLabel {
                self.view.addSubview(descriptionLabel)
                NSLayoutConstraint.activate(descriptionLabelConstraints)
            }
        }
    }
    private var termsLabel: OfferLabel? {
        didSet {
            if let termsLabel = self.termsLabel {
                self.view.addSubview(termsLabel)
                NSLayoutConstraint.activate(termsLabelConstraints)
            }
        }
    }

    // MARK: UI lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
    }
    
    // MARK: Constraints and constants for UI elements
    
    /// Used for the leading and trailing UI element margins
    private let leadingConstant = 16.0
    private let trailingConstant = -16.0
    
    private lazy var imageViewContainerConstraints: [NSLayoutConstraint] = {
        guard let offerDetailImageContainer = self.offerDetailImageContainer else {
            return [NSLayoutConstraint]()
        }
        
        return [
            offerDetailImageContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: leadingConstant),
            offerDetailImageContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: trailingConstant),
            offerDetailImageContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            offerDetailImageContainer.heightAnchor.constraint(equalToConstant: 200.0)
        ]
    }()
    
    private lazy var nameLabelConstraints: [NSLayoutConstraint] = {
        guard let nameLabel = self.nameLabel, let offerDetailImageContainer = self.offerDetailImageContainer else {
            return [NSLayoutConstraint]()
        }
        
        return [
            nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: leadingConstant),
            nameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: trailingConstant),
            nameLabel.topAnchor.constraint(equalTo: offerDetailImageContainer.bottomAnchor, constant: 24.0)
        ]
    }()
    
    private lazy var descriptionLabelConstraints: [NSLayoutConstraint] = {
        guard let nameLabel = self.nameLabel, let descriptionLabel = self.descriptionLabel else {
            return [NSLayoutConstraint]()
        }
        
        return [
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: leadingConstant),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: trailingConstant),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12.0)
        ]
    }()
    
    private lazy var termsLabelConstraints: [NSLayoutConstraint] = {
        guard let descriptionLabel = self.descriptionLabel, let termsLabel = self.termsLabel else {
            return [NSLayoutConstraint]()
        }
        
        return [
            termsLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: leadingConstant),
            termsLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: trailingConstant),
            termsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 11.0),
            termsLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor, constant: -8.0)
        ]
    }()
    
    // MARK: Set up UI elements
    
    func setupView() {
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        
        self.offerDetailImageContainer = ibottaUIKit.shared.offerDetailImageContainer(withFavoriteAction: { [weak self] in
            self?.viewModel?.toggleFavorite()
        })
        
        self.nameLabel = ibottaUIKit.shared.offerLabelWithStyle(.itemNameInDetail)
        viewModel?.bindSetName({ [weak self] text in
            self?.nameLabel?.text = text
        })
        
        self.descriptionLabel = ibottaUIKit.shared.offerLabelWithStyle(.descriptionInDetail)
        viewModel?.bindSetDescription({ [weak self] text in
            self?.descriptionLabel?.text = text
        })
        
        self.termsLabel = ibottaUIKit.shared.offerLabelWithStyle(.termsInDetail)
        viewModel?.bindSetTerms({ [weak self] text in
            self?.termsLabel?.text = text
        })
        
        viewModel?.bindSetFavorite({ [weak self] favorite in
            self?.offerDetailImageContainer?.setFavorite(favorite)
        })
        
        retrieveImage()
    }
        
    private func retrieveImage() {
        if let offer = viewModel?.offer, let url = offer.url, let image = ApplicationState.cachedImage(fromUrl: url) {
            offerDetailImageContainer?.setImage(image)
        } else {
            offerDetailImageContainer?.setImage(ibottaUIKit.shared.offerPlaceholderImage())
        }
    }
}
