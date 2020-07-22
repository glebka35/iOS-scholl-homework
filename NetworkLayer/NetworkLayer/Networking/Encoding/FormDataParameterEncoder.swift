//
//  FormDataParameterEncoder.swift
//  NetworkLayer
//
//  Created by Gleb Uvarkin on 22.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import Foundation

public struct FormDataParameterEncoder {
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters?, boundary: String, data: Data, mimeType: String, filename: String) {
        let body = NSMutableData()

        let boundaryPrefix = "--\(boundary)\r\n"

        if let parameters = parameters {
            for (key, value) in parameters {
                body.appendString(boundaryPrefix)
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }

        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))

        urlRequest.httpBody = body as Data
    }
}
