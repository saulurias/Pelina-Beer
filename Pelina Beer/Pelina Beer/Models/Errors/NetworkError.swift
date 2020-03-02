//
//  NetworkError.swift
//  Pelina Beer
//
//  Created by SaulUrias on 02/03/20.
//  Copyright © 2020 saulurias. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case serverError
    case invalidJSON(Error)
    case invalidStatusCode(Int)
    case noData
    case unknown(Error)
    
    var localizedDescription: String {
        switch self {
        case .serverError:
            return "Error on the Server"
        case .invalidJSON(let error):
            return "The JSON is not valid: \(error.localizedDescription)"
        case .invalidStatusCode(let code):
            return "Invalid Status Code: \(code)"
        case .noData:
            return "Data Not Found"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
