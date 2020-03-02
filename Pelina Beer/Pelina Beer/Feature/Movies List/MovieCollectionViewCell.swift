//
//  MovieCollectionViewCell.swift
//  Pelina Beer
//
//  Created by SaulUrias on 02/03/20.
//  Copyright © 2020 saulurias. All rights reserved.
//

import UIKit
import Kingfisher

protocol MovieCellDelegate: AnyObject {
    func movieCollectionViewCell(_ collectionViewCell: MovieCollectionViewCell, tappedFavorite button: UIButton)
}

final class MovieCollectionViewCell: UICollectionViewCell {
    // MARK: Constants and Variables
    private enum DesignConstants {
        static let titleFontSize: CGFloat = 17
        static let titleNumberOfLines = 2
        static let titleInsets = UIEdgeInsets(top: 5, left: 2, bottom: .zero, right: -2)
        static let posterHeight: CGFloat = 200
        static let favoriteButtonInsets = UIEdgeInsets(top: .zero, left: .zero, bottom: -2, right: -3)
        static let favoriteButtonSize = CGSize(width: 25, height: 25)
        static let ratingLabelWidth: CGFloat = 100
        static let ratingLabelBottomInset: CGFloat = -3
        static let optionsButtonSize = CGSize(width: 25, height: 25)
    }
    
    weak var delegate: MovieCellDelegate?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "placeholder"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: DesignConstants.titleFontSize)
        label.numberOfLines = DesignConstants.titleNumberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "hearth-icon"), for: .normal)
        button.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: View Life
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    // MARK: Functions
    private func setUpView() {
        addSubview(containerView)
        containerView.addSubview(posterImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(ratingLabel)
        containerView.addSubview(favoriteButton)
        
        containerView.setBorderShadow()
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: DesignConstants.posterHeight)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor,
                                                constant: DesignConstants.titleInsets.left),
            titleLabel.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor,
                                                 constant: DesignConstants.titleInsets.right),
            ratingLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                             constant: DesignConstants.ratingLabelBottomInset),
            ratingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingLabel.widthAnchor.constraint(equalToConstant: DesignConstants.ratingLabelWidth),
            favoriteButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                   constant: DesignConstants.favoriteButtonInsets.bottom),
            favoriteButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor,
                                                     constant: DesignConstants.favoriteButtonInsets.left),
            favoriteButton.heightAnchor.constraint(equalToConstant: DesignConstants.favoriteButtonSize.height),
            favoriteButton.widthAnchor.constraint(equalToConstant: DesignConstants.favoriteButtonSize.width)
        ])
    }
    
    @objc private func favoriteButtonPressed() {
        delegate?.movieCollectionViewCell(self, tappedFavorite: favoriteButton)
    }
    
    /// Configure outlet values
    /// - Parameters:
    ///   - movie: The movie values to be displayed
    ///   - isFavorite: The movie check to show favorite button icon
    func configure(with movie: Movie, isFavorite: Bool = false) {
        titleLabel.text = movie.title
        ratingLabel.text = "Rate: \(movie.voteAverage)"
        let favoriteIcon = isFavorite ? UIImage(named: "hearth-fill-icon") : UIImage(named: "hearth-icon")
        favoriteButton.setImage(favoriteIcon, for: .normal)
        favoriteButton.isHidden = isFavorite
        
        guard let url = URL(string: "\(APIManager.imageUrlBase)\(movie.posterPath)") else { return }
        displayPosterImage(from: url)
    }
    
    private func displayPosterImage(from url: URL) {
        posterImageView.kf.indicatorType = .activity
        posterImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
}
