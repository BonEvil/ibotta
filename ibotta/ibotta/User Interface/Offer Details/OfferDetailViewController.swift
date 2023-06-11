//
//  OfferDetailViewController.swift
//  ibotta
//
//  Created by Daniel Person on 6/10/23.
//

import UIKit

class OfferDetailViewController: UIViewController {
    
    var offer: Offer? {
        didSet {
            self.title = offer?.currentValue
        }
    }
    
    private lazy var wH: CGFloat = {
        return self.view.frame.size.width / 10
    }()
    
    private let favoriteTopValue = 12.0
    private let favoriteTrailingValue = -12.0

    private var imageView = UIImageView()
    private var nameLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var termsLabel = UILabel()
    private var favoriteButton = UIButton()
    private var favoriteImageView = UIImageView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = .white
        setupView()
    }
    
    // MARK: Constraints for UI elements
    
    private lazy var imageViewConstraints: [NSLayoutConstraint] = {
        return [
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16.0),
            imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16.0),
            imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 200.0)
        ]
    }()
    
    private lazy var nameLabelConstraints: [NSLayoutConstraint] = {
        return [
            nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16.0),
            nameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16.0),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24.0)
        ]
    }()
    
    private lazy var descriptionLabelConstraints: [NSLayoutConstraint] = {
        return [
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16.0),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16.0),
            descriptionLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 12.0)
        ]
    }()
    
    private lazy var termsLabelConstraints: [NSLayoutConstraint] = {
        return [
            termsLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16.0),
            termsLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16.0),
            termsLabel.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 11.0),
            termsLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor, constant: -8.0)
        ]
    }()
    
    private lazy var favoriteButtonConstraints: [NSLayoutConstraint] = {
        return [
            favoriteButton.heightAnchor.constraint(equalToConstant: wH),
            favoriteButton.widthAnchor.constraint(equalToConstant: wH),
            favoriteButton.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: favoriteTrailingValue),
            favoriteButton.topAnchor.constraint(equalTo: self.imageView.topAnchor, constant: favoriteTopValue)
        ]
    }()
    
    private lazy var favoriteImageConstraints: [NSLayoutConstraint] = {
        return [
            favoriteImageView.heightAnchor.constraint(equalToConstant: wH - 2),
            favoriteImageView.widthAnchor.constraint(equalToConstant: wH - 2),
            favoriteImageView.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: favoriteTrailingValue - 1),
            favoriteImageView.topAnchor.constraint(equalTo: self.imageView.topAnchor, constant: favoriteTopValue - 1)
        ]
    }()
    
    // MARK: Protocol setup method
    
    func setupView() {
        setupImageView()
        setupNameLabel()
        setupDescriptionLabel()
        setupTermsLabel()
        setupFavoriteButton()
        setupFavoriteImageView()
    }
    
    // MARK: UI element setup methods
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        if let offer = self.offer, let url = offer.url, let image = ApplicationState.cachedImage(fromUrl: url) {
            imageView.image = image
        } else {
            imageView.image = UIImage(named: Images.placeholder)
        }
        
        self.view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    private func setupNameLabel() {
        nameLabel.textColor = FontColors.main
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont(name: Fonts.demiBold, size: 18.0)
        nameLabel.text = offer?.name
        
        self.view.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(nameLabelConstraints)
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.textColor = FontColors.main
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont(name: Fonts.demiBold, size: 12.0)
        descriptionLabel.text = offer?.description
        
        self.view.addSubview(descriptionLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(descriptionLabelConstraints)
    }
    
    private func setupTermsLabel() {
        termsLabel.textColor = FontColors.main
        termsLabel.textAlignment = .left
        termsLabel.numberOfLines = 0
        termsLabel.font = UIFont(name: Fonts.regular, size: 11.0)
        termsLabel.text = offer?.terms
        
        self.view.addSubview(termsLabel)
        
        termsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(termsLabelConstraints)
    }
    
    private func setupFavoriteButton() {
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        favoriteButton.backgroundColor = .white
        favoriteButton.layer.cornerRadius = wH / 2
        favoriteButton.layer.borderColor = UIColor.white.cgColor
        favoriteButton.layer.borderWidth = 2.0
        
        self.view.addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(favoriteButtonConstraints)
    }
    
    private func setupFavoriteImageView() {
        setFavorite(ApplicationState.isFavorite(offer: offer))

        self.view.addSubview(favoriteImageView)
        favoriteImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(favoriteImageConstraints)
    }
    
    // MARK: Helper methods
    
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
            favoriteImageView.image = UIImage(systemName: Images.favoriteTrue)
        } else {
            ApplicationState.removeFavorite(offer: offer)
            favoriteImageView.tintColor = .systemGray
            favoriteImageView.image = UIImage(systemName: Images.favoriteFalse)
        }
    }
}
