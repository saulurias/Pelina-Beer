//
//  StatusResponse.swift
//  Pelina Beer
//
//  Created by SaulUrias on 02/03/20.
//  Copyright © 2020 saulurias. All rights reserved.
//

import Foundation

struct StatusResponse: Decodable {
    let statusCode: Int
    let statusMessage: String
}
