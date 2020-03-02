//
//  MovieServiceCallerProtocol.swift
//  Pelina Beer
//
//  Created by SaulUrias on 02/03/20.
//  Copyright © 2020 saulurias. All rights reserved.
//

import Foundation

protocol MovieServiceCallerProtocol {
    func getMovies(state: MovieListState, completion: @escaping(_ result: Result<MovieListResponse, NetworkError>) -> Void)
    func markAsFavorite(movie: Movie, isCurrentFavorite: Bool,
                        completion: @escaping (Result<StatusResponse, NetworkError>) -> Void)
}
