//
//  MovieServiceCaller.swift
//  Pelina Beer
//
//  Created by SaulUrias on 02/03/20.
//  Copyright © 2020 saulurias. All rights reserved.
//

import Foundation

struct MovieServiceCaller: MovieServiceCallerProtocol {
    func getMovies(state: MovieListState, completion: @escaping (Result<MovieListResponse, NetworkError>) -> Void) {
        let router = MovieRouter.getMovies(state: state)
        ServiceRequester.request(router: router) { (result: Result<MovieListResponse, NetworkError>) in
            completion(result)
        }
    }
    
    func markAsFavorite(movie: Movie, isCurrentFavorite: Bool,
                        completion: @escaping (Result<StatusResponse, NetworkError>) -> Void) {
        let router = MovieRouter.markAsFavorite(movie: movie, isCurrentFavorite: isCurrentFavorite)
        ServiceRequester.request(router: router) { (result: Result<StatusResponse, NetworkError>) in
            completion(result)
        }
    }
}
