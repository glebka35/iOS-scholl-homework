//
//  HTTPTask.swift
//  NetworkLayer
//
//  Created by Gleb Uvarkin on 25.06.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String:String]

public enum HTTPTask {
    case request
    case requestParameters(
        bodyParameters: Parameters?,
        bodyContentType: HTTPBodyContentType?,
        urlParameters: Parameters?)
    case requestParametersAndHeaders(
        bodyParameters: Parameters?,
        bodyContentType: HTTPBodyContentType?,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
}
