//
//  MovieDetailView.swift
//  Pelina Beer
//
//  Created by SaulUrias on 02/03/20.
//  Copyright © 2020 saulurias. All rights reserved.
//

import UIKit

protocol MovieDetailDelegate: AnyObject {
    func movieDetailView(_ view: MovieDetailView, tappedFavorite button: UIButton)
}

final class MovieDetailView: NiblessView {
    // MARK: Constants and Variables
    private enum DesignConstants {
        static let titleFontSize: CGFloat = 27
        static let titleNumberOfLines: Int = .zero
        static let titleInsets = UIEdgeInsets(top: 5, left: 2, bottom: .zero, right: -2)
        static let posterHeight: CGFloat = 350
        static let favoriteButtonInsets = UIEdgeInsets(top: 5, left: .zero, bottom: -2, right: -10)
        static let favoriteButtonSize = CGSize(width: 25, height: 25)
        static let ratingLabelWidth: CGFloat = 100
        static let ratingLabelBottomInset: CGFloat = -3
        static let overViewFontsize: CGFloat = 20
    }
    
    weak var delegate: MovieDetailDelegate?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "placeholder"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "hearth-icon"), for: .normal)
        button.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = .systemFont(ofSize: DesignConstants.overViewFontsize)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let movie: Movie
    private let isFavorite: Bool
    
    // MARK: View Life Cycle
    init(movie: Movie, isFavorite: Bool) {
        self.movie = movie
        self.isFavorite = isFavorite
        super.init()
        setUpView()
        configureOutlets()
    }
    
    private func setUpView() {
        backgroundColor = .white
        addSubview(scrollView)
        scrollView.addSubview(posterImageView)
        scrollView.addSubview(favoriteButton)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(ratingLabel)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(overviewTextView)
        
        NSLayoutConstraint.activate([
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: topAnchor),
            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: DesignConstants.posterHeight)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor,
                                                constant: DesignConstants.titleInsets.left),
            titleLabel.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor,
                                                 constant: DesignConstants.titleInsets.right),
            favoriteButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DesignConstants.favoriteButtonInsets.top),
            favoriteButton.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: DesignConstants.favoriteButtonInsets.right),
            favoriteButton.heightAnchor.constraint(equalToConstant: DesignConstants.favoriteButtonSize.height),
            favoriteButton.widthAnchor.constraint(equalToConstant: DesignConstants.favoriteButtonSize.width),
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                             constant: DesignConstants.ratingLabelBottomInset),
            ratingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingLabel.widthAnchor.constraint(equalToConstant: DesignConstants.ratingLabelWidth),
            dateLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: ratingLabel.leadingAnchor),
            overviewTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: DesignConstants.favoriteButtonInsets.bottom),
            overviewTextView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            overviewTextView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            overviewTextView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }
        
    // MARK: Functions
    private func configureOutlets() {
        titleLabel.text = movie.title
        ratingLabel.text = "Rate: \(movie.voteAverage)"
        dateLabel.text = movie.releaseDate
        overviewTextView.text = movie.overview
        let favoriteIcon = isFavorite ? UIImage(named: "hearth-fill-icon") : UIImage(named: "hearth-icon")
        favoriteButton.setImage(favoriteIcon, for: .normal)
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
    
    @objc private func favoriteButtonPressed() {
        delegate?.movieDetailView(self, tappedFavorite: favoriteButton)
    }
}
