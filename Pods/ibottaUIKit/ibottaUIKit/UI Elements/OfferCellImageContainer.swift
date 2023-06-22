//
//  OfferCellImageContainer.swift
//  ibottaUIKit
//
//  Created by Daniel Person on 6/20/23.
//

import UIKit

public class OfferCellImageContainer: UIView {
    
    private let imageView = UIImageView()
    private var favoriteImageView = UIImageView()
    
    func setup() {
        setupSelf()
        setupImageView()
        setupFavoriteImageView()
    }
    
    // MARK: Public methods
    
    public func setImage(_ image: UIImage?) {
        self.imageView.image = image
    }
    
    public func setFavorite(_ favorite: Bool) {
        if favorite {
            favoriteImageView.isHidden = false
        } else {
            favoriteImageView.isHidden = true
        }
    }
    
    // MARK: Constants and constraints
    
    private let topLeadingConstant = 6.0
    private let bottomTrailingConstant = -6.0
    private let imageWidthHeight: CGFloat = 20.0
    
    private lazy var imageViewConstraints: [NSLayoutConstraint] = {
        return [
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: topLeadingConstant),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: bottomTrailingConstant),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: topLeadingConstant),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: bottomTrailingConstant)
        ]
    }()
    
    private lazy var favoriteImageViewConstraints: [NSLayoutConstraint] = {
        return [
            favoriteImageView.heightAnchor.constraint(equalToConstant: imageWidthHeight),
            favoriteImageView.widthAnchor.constraint(equalToConstant: imageWidthHeight),
            favoriteImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: topLeadingConstant),
            favoriteImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: bottomTrailingConstant)
        ]
    }()
    
    // MARK: Setup
    
    private func setupSelf() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.init(white: 0.0, alpha: 0.2)
        self.layer.cornerRadius = 5.0
    }

    private func setupImageView() {
        self.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    private func setupFavoriteImageView() {
        self.addSubview(favoriteImageView)
        favoriteImageView.tintColor = .systemYellow
        favoriteImageView.backgroundColor = .white
        favoriteImageView.layer.cornerRadius = imageWidthHeight / 2
        favoriteImageView.image = UIImage(systemName: "star.fill")
        favoriteImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(favoriteImageViewConstraints)
    }
}
