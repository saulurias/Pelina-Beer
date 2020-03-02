//
//  MovieRouter.swift
//  Pelina Beer
//
//  Created by SaulUrias on 02/03/20.
//  Copyright © 2020 saulurias. All rights reserved.
//

import Foundation
import Alamofire

enum MovieRouter: URLRequestConvertible {
    
    case getMovies(state: MovieListState)
    case markAsFavorite(movie: Movie, isCurrentFavorite: Bool)
    
    var method: HTTPMethod {
        switch self {
            
        case .getMovies:
            return .get
            
        case .markAsFavorite:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getMovies(let state):
            switch state {
            case .feed:
                return "/movie/popular"
            case .filtered:
                return "/search/movie"
            case .favorite:
                return "/account/\(SecretKey.idAccount)/favorite/movies"
            }
            
        case .markAsFavorite:
            return "account/\(SecretKey.idAccount)/favorite"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getMovies(let state):
            switch state {
            case .feed:
                return [
                    "api_key": SecretKey.apiKey,
                    "language": "en-US"
                ]
                
            case .filtered(let query):
                return [
                    "api_key": SecretKey.apiKey,
                    "query": query,
                    "language": "en-US"
                ]
                
            case .favorite:
                return [
                    "api_key": SecretKey.apiKey,
                    "session_id": SecretKey.idSession,
                    "sort_by": "created_at.desc",
                    "language": "en-US"
                ]
            }
            
        case .markAsFavorite(let movie, let isCurrentFavorite):
            return [
                "api_key": SecretKey.apiKey,
                "session_id": SecretKey.idSession,
                "media_type": "movie",
                "media_id": movie.id,
                "favorite": !isCurrentFavorite
            ]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        switch self {
        case .getMovies, .markAsFavorite:
            let url = try APIManager.urlBase.asURL()
            var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
            urlRequest.httpMethod = method.rawValue
            urlRequest.setValue("bearer \(SecretKey.accesstoken)", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
            
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            return urlRequest
        }
    }
}
