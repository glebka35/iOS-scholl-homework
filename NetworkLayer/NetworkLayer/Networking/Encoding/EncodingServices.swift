//
//  ParameterEncoding.swift
//  NetworkLayer
//
//  Created by Gleb Uvarkin on 25.06.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import Foundation

public typealias Parameters = [String:Any]

public enum NetworkError : String, Error {
    case parameterNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed"
    case missingURL = "URL is nil."
    case missingProvider = "Provider is nil"
}
