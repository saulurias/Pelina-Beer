//
//  MovieListResponse.swift
//  Pelina Beer
//
//  Created by SaulUrias on 02/03/20.
//  Copyright © 2020 saulurias. All rights reserved.
//

import Foundation

struct MovieListResponse: Decodable {
    var movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}
