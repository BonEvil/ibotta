//
//  OfferDetailImageContainer.swift
//  ibottaUIKit
//
//  Created by Daniel Person on 6/21/23.
//

import UIKit

public class OfferDetailImageContainer: UIView {

    private let imageView = UIImageView()
    private let favoriteButton = UIButton(type: .custom)
    
    private var favoriteAction: (() -> Void)?

    func setup(withFavoriteAction favoriteAction: @escaping (() -> Void)){
        self.favoriteAction = favoriteAction
        
        setupSelf()
        setupImageView()
        setupFavoriteButton()
    }
    
    @objc
    func performFavoriteAction() {
        favoriteAction?()
    }
    
    // MARK: Public methods
    
    public func setImage(_ image: UIImage?) {
        self.imageView.image = image
    }
    
    public func setFavorite(_ favorite: Bool) {
        if favorite {
            favoriteButton.tintColor = .systemYellow
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favoriteButton.tintColor = .systemGray
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    // MARK: Constants and contstraints
    
    /// Used for the leading and trailing UI element margins
    private let leadingConstant = 16.0
    private let trailingConstant = -16.0
    private let favoriteButtonWidthHeight = 40.0
    
    private lazy var imageViewConstraints: [NSLayoutConstraint] = {
        return [
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingConstant),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailingConstant),
            imageView.topAnchor.constraint(equalTo: self.topAnchor,constant: leadingConstant),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: trailingConstant)
        ]
    }()
    
    private lazy var favoriteButtonContstraints: [NSLayoutConstraint] = {
        return [
            favoriteButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: leadingConstant),
            favoriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: trailingConstant),
            favoriteButton.heightAnchor.constraint(equalToConstant: favoriteButtonWidthHeight),
            favoriteButton.widthAnchor.constraint(equalToConstant: favoriteButtonWidthHeight)
        ]
    }()
    
    // MARK: Setup
    
    private func setupSelf() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.init(white: 1.0, alpha: 0.2)
        self.layer.cornerRadius = 6.0
    }
    
    private func setupImageView() {
        self.imageView.contentMode = .scaleAspectFit
        self.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(imageViewConstraints)
    }

    private func setupFavoriteButton() {
        self.addSubview(self.favoriteButton)
        self.favoriteButton.addTarget(self, action: #selector(performFavoriteAction), for: .touchUpInside)
        self.favoriteButton.backgroundColor = .white
        self.favoriteButton.layer.cornerRadius = favoriteButtonWidthHeight / 2
        self.favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(favoriteButtonContstraints)
    }
}
