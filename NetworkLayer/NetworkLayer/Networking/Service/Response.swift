//
//  Response.swift
//  NetworkLayer
//
//  Created by Gleb Uvarkin on 06.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import Foundation

public struct Response {
    let data: Data?
    let statusCode: Int
    let headers: [AnyHashable: Any]
}
