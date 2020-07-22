//
//  HTTPBodyContentType.swift
//  NetworkLayer
//
//  Created by Gleb Uvarkin on 21.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import Foundation

public enum HTTPBodyContentType {
    case urlEncoded
    case jsonEncoded
    case multipartFormData(
        boundary: String,
        data: Data,
        mimeType: String,
        filename: String)

    func encode(urlRequest: inout URLRequest,
                bodyParameters: Parameters?) throws {
        do {
            switch self {
            case .jsonEncoded:
                try JSONParameterEncoder.encode(urlRequest: &urlRequest, with: bodyParameters)
            case .urlEncoded:
                try URLParameterEncoder.encode(urlRequest: &urlRequest, with: bodyParameters, isBody: true)
            case .multipartFormData(let boundary, let data, let mimeType, let filename):
                FormDataParameterEncoder.encode(urlRequest: &urlRequest, with: bodyParameters, boundary: boundary, data: data, mimeType: mimeType, filename: filename)
            }
        }
    }
}
