//
//  ServiceRequester.swift
//  Pelina Beer
//
//  Created by SaulUrias on 02/03/20.
//  Copyright © 2020 saulurias. All rights reserved.
//

import Foundation
import Alamofire

final class ServiceRequester {
    class func request<T: Decodable>(router: URLRequestConvertible,
                                     completion: @escaping (Swift.Result<T, NetworkError>) -> Void) {
        Alamofire.request(router).responseJSON { result in
            do {
                guard let data = result.data else {
                    return completion(.failure(.noData))
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let responseObject = try decoder.decode(T.self, from: data)
                
                return completion(.success(responseObject))
            } catch {
                return completion(.failure(.invalidJSON(error)))
            }
        }
    }
}
