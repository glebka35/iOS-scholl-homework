//
//  CloudMersiveResponse.swift
//  NetworkLayer
//
//  Created by Gleb Uvarkin on 25.06.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import Foundation

struct CloudMersiveApiResponse {
    let successful: Bool
    let objects: [Object]
    let objectCount: Int
}

extension CloudMersiveApiResponse: Decodable {
    
    private enum CloudMersiveApiResponseCodingKeys: String, CodingKey {
        case success = "Successful"
        case objects = "Objects"
        case objectCount = "ObjectCount"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CloudMersiveApiResponseCodingKeys.self)
        
        successful = try container.decode(Bool.self, forKey: .success)
        objectCount = try container.decode(Int.self, forKey: .objectCount)
        objects = try container.decode([Object].self, forKey: .objects)
    }
}

struct Object {
    let objectClassName: String
    let height: Int
    let width: Int
    let score: Double
    let x: Int
    let y: Int
}

extension Object: Decodable {
    
    enum ObjectCodingKeys: String, CodingKey {
        case objectClassName = "ObjectClassName"
        case height = "Height"
        case width = "Width"
        case score = "Score"
        case x = "X"
        case y = "Y"
    }
    
    init(from decoder: Decoder) throws {
        let objectContainer = try decoder.container(keyedBy: ObjectCodingKeys.self)
        
        objectClassName = try objectContainer.decode(String.self, forKey: .objectClassName)
        height = try objectContainer.decode(Int.self, forKey: .height)
        width = try objectContainer.decode(Int.self, forKey: .width)
        score = try objectContainer.decode(Double.self, forKey: .score)
        x = try objectContainer.decode(Int.self, forKey: .x)
        y = try objectContainer.decode(Int.self, forKey: .y)
    }
}
