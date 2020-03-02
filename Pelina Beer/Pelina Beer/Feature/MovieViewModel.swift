//
//  MovieViewModel.swift
//  Pelina Beer
//
//  Created by SaulUrias on 02/03/20.
//  Copyright © 2020 saulurias. All rights reserved.
//

import Foundation

final class MovieViewModel {
    // MARK: Constants and Variables
    let serviceCaller: MovieServiceCallerProtocol
    private var movies: [Movie] = []
    private var filteredMovies: [Movie] = []
    private var favoriteMovies: [Movie] = []
    var networkError: Box<NetworkError?> = Box(nil)
    var didLoadMovies: Box<Bool?> = Box(nil)
    var addedToWatchList: Box<Bool?> = Box(nil)
    var movieListState: MovieListState = .feed
    
    // MARK: Init
    init(serviceCaller: MovieServiceCallerProtocol = MovieServiceCaller()) {
        self.serviceCaller = serviceCaller
        reloadFavoriteMovies()
    }
    
    // MARK: Functions
    func getMovie(at index: Int) -> Movie? {
        switch movieListState {
        case .feed:
            return movies[safe: index]
        case .filtered:
            return filteredMovies[safe: index]
        case .favorite:
            return favoriteMovies[safe: index]
        }
    }
    
    func totalMovies() -> Int {
        switch movieListState {
        case .feed:
            return movies.count
        case .filtered:
            return filteredMovies.count
        case .favorite:
            return favoriteMovies.count
        }
    }
    
    private func checkPreloadedMovies() -> Bool {
        switch movieListState {
        case .feed: return movies.isEmpty
        case .favorite: return favoriteMovies.isEmpty
        default: return true
        }
    }
    
    func isFavorite(movie: Movie) -> Bool {
        return favoriteMovies.contains { favoriteMovie -> Bool in
            return movie.id == favoriteMovie.id
        }
    }
}

// MARK: - Service Requests
extension MovieViewModel {
    func loadMovies() {
        if checkPreloadedMovies() {
            serviceCaller.getMovies(state: movieListState) { result in
                switch result {
                case .success(let moviesResponse):
                    print("Did load movies")
                    switch self.movieListState {
                    case .feed:
                        self.movies = moviesResponse.movies
                    case .filtered:
                        self.filteredMovies = moviesResponse.movies
                    case .favorite:
                        self.favoriteMovies = moviesResponse.movies
                    }
                    self.didLoadMovies.value = true
                case .failure(let error):
                    self.didLoadMovies.value = false
                    self.networkError.value = error
                }
            }
        } else {
            print("Pre loaded movies")
            self.didLoadMovies.value = true
        }
    }
    
    private func reloadFavoriteMovies() {
        serviceCaller.getMovies(state: .favorite) { result in
            switch result {
            case .success(let moviesResponse):
                self.favoriteMovies = moviesResponse.movies
                self.didLoadMovies.value = true
            case .failure(let error):
                self.networkError.value = error
            }
        }
    }
    
    func markAsFavorite(_ movie: Movie) {
        serviceCaller.markAsFavorite(movie: movie, isCurrentFavorite: isFavorite(movie: movie)) { result in
            switch result {
            case .success:
                self.reloadFavoriteMovies()
            case .failure(let error):
                self.networkError.value = error
            }
        }
    }
}
