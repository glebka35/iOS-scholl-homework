//
//  ApiSettings.swift
//  NetworkLayer
//
//  Created by Gleb Uvarkin on 07.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import Foundation

public enum NetworkEnvironment {
    case qa
    case production
    case staging
}

public struct ClientSettings {
    let baseURL: URL
    var environment: NetworkEnvironment
    var baseHeaders: HTTPHeaders?
}
