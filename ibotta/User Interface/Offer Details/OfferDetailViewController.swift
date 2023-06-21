//
//  OfferDetailViewController.swift
//  ibotta
//
//  Created by Daniel Person on 6/10/23.
//

import ibottaUIKit

class OfferDetailViewController: UIViewController {
    
    var offer: Offer? {
        didSet {
            self.title = offer?.currentValue
        }
    }
    
    // MARK: UI elements

    private var imageView = UIImageView()
    private var nameLabel: UILabel? {
        didSet {
            if let nameLabel = self.nameLabel {
                nameLabel.text = offer?.name
                self.view.addSubview(nameLabel)
                NSLayoutConstraint.activate(nameLabelConstraints)
            }
        }
    }
    private var descriptionLabel: UILabel? {
        didSet {
            if let descriptionLabel = self.descriptionLabel {
                descriptionLabel.text = offer?.description
                self.view.addSubview(descriptionLabel)
                NSLayoutConstraint.activate(descriptionLabelConstraints)
            }
        }
    }
    private var termsLabel: UILabel? {
        didSet {
            if let termsLabel = self.termsLabel {
                termsLabel.text = offer?.terms
                self.view.addSubview(termsLabel)
                NSLayoutConstraint.activate(termsLabelConstraints)
            }
        }
    }
    private var favoriteButton = UIButton()
    private var favoriteImageView = UIImageView()
    
    // MARK: UI lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.addSubview(imageView)
        
        self.nameLabel = ibottaUIKit.shared.labelWithStyle(.itemNameInDetail, andText: offer?.name)
        self.descriptionLabel = ibottaUIKit.shared.labelWithStyle(.descriptionInDetail, andText: offer?.description)
        self.termsLabel = ibottaUIKit.shared.labelWithStyle(.termsInDetail, andText: offer?.terms)
        
        self.view.addSubview(favoriteButton)
        self.view.addSubview(favoriteImageView)
        
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        setupView()
    }
    
    // MARK: Constraints and constants for UI elements
    
    /// Used to dynamically size the `favoriteButton` according to screen size
    private lazy var wH: CGFloat = {
        return self.view.frame.size.width / 10
    }()
    
    /// Used to position the `favoriteButton`
    private let favoriteTopConstant = 12.0
    private let favoriteTrailingConstant = -12.0
    
    /// Used for the leading and trailing UI element margins
    private let leadingConstant = 16.0
    private let trailingConstant = -16.0
    
    /// Font sizes for labels
    private let nameLabelFontSize = 18.0
    private let descriptionLabelFontSize = 12.0
    private let termsLabelFontSize = 11.0
    
    private lazy var imageViewConstraints: [NSLayoutConstraint] = {
        return [
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: leadingConstant),
            imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: trailingConstant),
            imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 200.0)
        ]
    }()
    
    private lazy var nameLabelConstraints: [NSLayoutConstraint] = {
        guard let nameLabel = self.nameLabel else {
            return [NSLayoutConstraint]()
        }
        
        return [
            nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: leadingConstant),
            nameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: trailingConstant),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24.0)
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
    
    private lazy var favoriteButtonConstraints: [NSLayoutConstraint] = {
        return [
            favoriteButton.heightAnchor.constraint(equalToConstant: wH),
            favoriteButton.widthAnchor.constraint(equalToConstant: wH),
            favoriteButton.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: favoriteTrailingConstant),
            favoriteButton.topAnchor.constraint(equalTo: self.imageView.topAnchor, constant: favoriteTopConstant)
        ]
    }()
    
    private lazy var favoriteImageConstraints: [NSLayoutConstraint] = {
        return [
            favoriteImageView.heightAnchor.constraint(equalToConstant: wH - 2),
            favoriteImageView.widthAnchor.constraint(equalToConstant: wH - 2),
            favoriteImageView.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: favoriteTrailingConstant - 1),
            favoriteImageView.topAnchor.constraint(equalTo: self.imageView.topAnchor, constant: favoriteTopConstant - 1)
        ]
    }()
    
    // MARK: Set up UI elements
    
    func setupView() {
        setupImageView()
        setupFavoriteButton()
        setupFavoriteImageView()
        
        retrieveImage()
    }
    
    // MARK: UI element setup methods
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    private func retrieveImage() {
        if let offer = self.offer, let url = offer.url, let image = ApplicationState.cachedImage(fromUrl: url) {
            imageView.image = image
        } else {
            imageView.image = UIImage(named: ImageNames.placeholder)
        }
    }
    
    private func setupFavoriteButton() {
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        favoriteButton.backgroundColor = .white
        favoriteButton.layer.cornerRadius = wH / 2
        favoriteButton.layer.borderColor = UIColor.white.cgColor
        favoriteButton.layer.borderWidth = 2.0
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(favoriteButtonConstraints)
    }
    
    private func setupFavoriteImageView() {
        setFavorite(ApplicationState.isFavorite(offer: offer))
        favoriteImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(favoriteImageConstraints)
    }
    
    // MARK: Update UI for favorite
    
    @objc
    private func toggleFavorite() {
        
        if ApplicationState.isFavorite(offer: offer) {
            setFavorite(false)
        } else {
            setFavorite(true)
        }
    }
    
    private func setFavorite(_ favorite: Bool) {        
        if favorite {
            ApplicationState.addFavorite(offer: offer)
            favoriteImageView.tintColor = .systemYellow
            favoriteImageView.image = UIImage(systemName: ImageNames.favoriteTrue)
        } else {
            ApplicationState.removeFavorite(offer: offer)
            favoriteImageView.tintColor = .systemGray
            favoriteImageView.image = UIImage(systemName: ImageNames.favoriteFalse)
        }
    }
}
