//
//  APIManager.swift
//  Pelina Beer
//
//  Created by SaulUrias on 02/03/20.
//  Copyright © 2020 saulurias. All rights reserved.
//

import Foundation

struct APIManager {
    static let urlBase: String = "https://api.themoviedb.org/3"
    static let imageUrlBase: String = "https://image.tmdb.org/t/p/w500"
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
}
