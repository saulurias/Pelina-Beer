//
//  Movie.swift
//  Pelina Beer
//
//  Created by SaulUrias on 02/03/20.
//  Copyright © 2020 saulurias. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let title: String
    let voteAverage: Double
    let posterPath: String
    let overview: String
    let releaseDate: String
}
