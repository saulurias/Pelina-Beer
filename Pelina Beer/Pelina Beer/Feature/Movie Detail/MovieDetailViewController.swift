//
//  MovieDetailViewController.swift
//  Pelina Beer
//
//  Created by SaulUrias on 02/03/20.
//  Copyright © 2020 saulurias. All rights reserved.
//

import UIKit

final class MovieDetailViewController: NiblessViewController {
    // MARK: Constants and Variables
    private var detailView: MovieDetailView
    private let movie: Movie
    private let viewModel: MovieViewModel
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    init(movie: Movie, viewModel: MovieViewModel) {
        self.movie = movie
        self.viewModel = viewModel
        self.detailView = MovieDetailView(movie: movie, isFavorite: viewModel.isFavorite(movie: movie))
        super.init()
    }
    
    // MARK: Functions
    private func setUpView() {
        title = "Movie Detail"
        view.backgroundColor = .white
        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailView.delegate = self
        view.addSubview(detailView)
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: MovieDetailDelegate
extension MovieDetailViewController: MovieDetailDelegate {
    func movieDetailView(_ view: MovieDetailView, tappedFavorite button: UIButton) {
        viewModel.markAsFavorite(movie)
    }
}
