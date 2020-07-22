//
//  ApiSettings.swift
//  NetworkLayer
//
//  Created by Gleb Uvarkin on 07.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import Foundation

protocol ClientSettingsProviderProtocol {
    var settings: ClientSettings { get }
    var baseURL: URL { get }
}

public struct ClientSettings {
    var baseHeaders: HTTPHeaders?
}
