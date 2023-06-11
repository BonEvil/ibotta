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

    var imageView = UIImageView()
    var nameLabel = UILabel()
    var descriptionLabel = UILabel()
    var termsLabel = UILabel()
    var favoriteButton = UIButton()
    var favoriteImageView = UIImageView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = .white
        setupView()
    }
    
    // MARK: Constraint graphs for UI elements
    
    private lazy var imageViewConstraintGraph: ConstraintGraph = {
        let constraintGraph = ConstraintGraph(height: 200.0, leadingAnchor: 16.0, trailingAnchor: -16.0)
        return constraintGraph
    }()
    
    private lazy var nameLabelConstraintGraph: ConstraintGraph = {
        let constraintGraph = ConstraintGraph(leadingAnchor: 16.0, topAnchor: 24.0, trailingAnchor: -16.0)
        return constraintGraph
    }()
    
    private lazy var descriptionLabelConstraintGraph: ConstraintGraph = {
        let constraintGraph = ConstraintGraph(leadingAnchor: 16.0, topAnchor: 12.0, trailingAnchor: -16.0)
        return constraintGraph
    }()
    
    private lazy var termsLabelConstraintGraph: ConstraintGraph = {
        let constraintGraph = ConstraintGraph(leadingAnchor: 16.0, topAnchor: 11.0, trailingAnchor: -16.0, bottomAnchor: -8.0)
        return constraintGraph
    }()
    
    private lazy var favoriteButtonConstraintGraph: ConstraintGraph = {
        let wH = self.view.frame.size.width / 10
        let constraintGraph = ConstraintGraph(width: wH, height: wH, topAnchor: 12.0,trailingAnchor: -12.0)
        return constraintGraph
    }()
    
    private lazy var favoriteImageConstraintGraph: ConstraintGraph = {
        let referenceConstraintGraph = favoriteButtonConstraintGraph
        let constraintGraph = ConstraintGraph(width: referenceConstraintGraph.width - 2, height: referenceConstraintGraph.height - 2, topAnchor: referenceConstraintGraph.topAnchor + 1, trailingAnchor: referenceConstraintGraph.trailingAnchor - 1)
        return constraintGraph
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
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: imageViewConstraintGraph.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: imageViewConstraintGraph.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: imageViewConstraintGraph.height)
        ])
    }
    
    private func setupNameLabel() {
        nameLabel.textColor = UIColor(named: Fonts.fontColor)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont(name: Fonts.demiBold, size: 18.0)
        nameLabel.text = offer?.name
        
        self.view.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: nameLabelConstraintGraph.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: nameLabelConstraintGraph.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: nameLabelConstraintGraph.topAnchor)
        ])
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.textColor = UIColor(named: Fonts.fontColor)
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont(name: Fonts.demiBold, size: 12.0)
        descriptionLabel.text = offer?.description
        
        self.view.addSubview(descriptionLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: descriptionLabelConstraintGraph.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: descriptionLabelConstraintGraph.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: descriptionLabelConstraintGraph.topAnchor)
        ])
    }
    
    private func setupTermsLabel() {
        termsLabel.textColor = UIColor(named: Fonts.fontColor)
        termsLabel.textAlignment = .left
        termsLabel.numberOfLines = 0
        termsLabel.font = UIFont(name: Fonts.regular, size: 11.0)
        termsLabel.text = offer?.terms
        
        self.view.addSubview(termsLabel)
        
        termsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            termsLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: termsLabelConstraintGraph.leadingAnchor),
            termsLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: termsLabelConstraintGraph.trailingAnchor),
            termsLabel.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: termsLabelConstraintGraph.topAnchor),
            termsLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor, constant: termsLabelConstraintGraph.bottomAnchor)
        ])
    }
    
    private func setupFavoriteButton() {
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        favoriteButton.backgroundColor = .white
        favoriteButton.layer.cornerRadius = favoriteButtonConstraintGraph.width / 2
        favoriteButton.layer.borderColor = UIColor.white.cgColor
        favoriteButton.layer.borderWidth = 2.0
        
        self.view.addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favoriteButton.heightAnchor.constraint(equalToConstant: favoriteButtonConstraintGraph.height),
            favoriteButton.widthAnchor.constraint(equalToConstant: favoriteButtonConstraintGraph.width),
            favoriteButton.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: favoriteButtonConstraintGraph.trailingAnchor),
            favoriteButton.topAnchor.constraint(equalTo: self.imageView.topAnchor, constant: favoriteButtonConstraintGraph.topAnchor)
        ])
    }
    
    private func setupFavoriteImageView() {
        setFavorite(ApplicationState.isFavorite(offer: offer))

        self.view.addSubview(favoriteImageView)
        favoriteImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favoriteImageView.heightAnchor.constraint(equalToConstant: favoriteImageConstraintGraph.height),
            favoriteImageView.widthAnchor.constraint(equalToConstant: favoriteImageConstraintGraph.width),
            favoriteImageView.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: favoriteImageConstraintGraph.trailingAnchor),
            favoriteImageView.topAnchor.constraint(equalTo: self.imageView.topAnchor, constant: favoriteImageConstraintGraph.topAnchor)
        ])
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
