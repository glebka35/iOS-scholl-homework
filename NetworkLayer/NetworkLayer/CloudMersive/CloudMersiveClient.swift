//
//  CloudMersiveApi.swift
//  NetworkLayer
//
//  Created by Gleb Uvarkin on 07.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import Foundation
import UIKit

struct HTTPProvider: ClientSettingsProviderProtocol {
    var settings: ClientSettings
    var baseURL: URL
}

enum Environment {
    case prod
    case debug
    case adhoc
}

class CloudMersiveClient {
    
    var baseURL = URL(string: "https://api.cloudmersive.com")!
    var boundary = "Boundary-\(UUID().uuidString)"
    var headers: HTTPHeaders
    
    private let networkManager: ApiClient
    private var settings: ClientSettings
    
    
    init() {
        headers = ["Apikey": "d90f3529-f5d3-4048-9d7c-46a4a35829c4", "Content-Type":"multipart/form-data; boundary=\(boundary)"]
        
        settings = ClientSettings(baseHeaders: headers)
        let provider = HTTPProvider(settings: settings, baseURL: baseURL)
        networkManager = ApiClient(provider: provider)
    }
    
    func getRecognition(of image: Data?, name: String, completion: @escaping (_ objects: [Object]?, _ success: Bool?)->()) {
        if let data = image {
            let request = Request(path: "/image/recognize/detect-objects", httpMethod: .post, task: .requestParametersAndHeaders(bodyParameters: nil, bodyContentType: .multipartFormData(boundary: boundary, data: data, mimeType: "image/jpg", filename: name), urlParameters: nil, additionHeaders: nil))

//            .requestFormDataAndHeaders(urlParameters: nil, additionHeaders: headers, boundary: boundary, data: data, mimeType: "image/jpg", filename: name)
            
            networkManager.execute(request: request) {(response, error) in
                if let response = response {
                    print(response.statusCode)
                    if let data = response.data {
                        do {
                            let apiResponse = try JSONDecoder().decode(CloudMersiveApiResponse.self, from: data)
                            completion(apiResponse.objects, apiResponse.successful)
                        } catch {
                            print("Can not decode response")
                            completion(nil, nil)
                        }
                    }
                } else {
                    print("error: response is nil")
                    completion(nil, nil)
                }
            }
        }
    }
    
    private func decodeResponse(response: Response)->[Object]? {
        guard let data = response.data else { return nil }
        do {
            let apiResponse = try JSONDecoder().decode(CloudMersiveApiResponse.self, from: data)
            return apiResponse.objects
        } catch {
            print("Can not decode response")
            return nil
        }
    }
}
