//
//  URLParameterEncoder.swift
//  NetworkLayer
//
//  Created by Gleb Uvarkin on 25.06.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import Foundation

public struct URLParameterEncoder {
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters?, isBody: Bool) throws {
        
        guard let url = urlRequest.url else { throw NetworkError.missingURL }
        guard let parameters = parameters else { throw NetworkError.parameterNil }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)) 
                    urlComponents.queryItems?.append(queryItem)
            }
            if isBody {
                urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
            } else {
                urlRequest.url = urlComponents.url
            }
        }
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}
