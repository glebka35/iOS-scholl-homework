//
//  CloudMersiveEndPoint.swift
//  NetworkLayer
//
//  Created by Gleb Uvarkin on 25.06.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import Foundation
import UIKit

public struct Request {
    var headers: HTTPHeaders?
    var boundary: String
    var path: String
    var httpMethod: HTTPMethod
    var task: HTTPTask
}
