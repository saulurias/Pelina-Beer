//
//  MovieListState.swift
//  Pelina Beer
//
//  Created by SaulUrias on 02/03/20.
//  Copyright © 2020 saulurias. All rights reserved.
//

import Foundation

enum MovieListState {
    case feed
    case filtered(query: String)
    case favorite
}
