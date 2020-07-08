//
//  NetworkManager.swift
//  NetworkLayer
//
//  Created by Gleb Uvarkin on 25.06.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import Foundation

class ApiClient: NetworkManager {
    var settings: ClientSettings
    
//    MARK: - API usage with request and settings
    
    init(settings: ClientSettings) {
        self.settings = settings
    }

    func execute(request: Request, with completion: @escaping (_ apiResponse: Response?, _ error: Error?)->()) {
        performRequest(request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                let apiResponse = Response(data: data, statusCode: response.statusCode, headers: response.allHeaderFields)
                completion(apiResponse, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
//    MARK: - Request performing
    
    private func performRequest(_ route: Request, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?)->()) {
        var task: URLSessionTask?
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        task?.resume()
    }
    
//    MARK: - Converting request in URLRequser
    
    private func buildRequest(from route: Request) throws -> URLRequest {
        var request = URLRequest(url: settings.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20.0)
        
        if let baseHeaders = settings.baseHeaders {
            addAdditionalHeaders(baseHeaders, request: &request)
        }
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            case .requestParameters(let bodyParameters, let urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters, let urlParameters, let additionalHeaders):
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
                
            case .requestFormDataAndHeaders(let bodyParameters, let urlParameters, let additionHeaders, let boundary, let data, let mimeType, let filename):
                self.addAdditionalHeaders(additionHeaders, request: &request)
                try self.configureParameters(bodyParameters: nil, urlParameters: urlParameters, request: &request)
                request.httpBody = createFormDataBody(bodyParameters, boundary, data, mimeType, filename)
            }
            return request
        } catch {
            throw error
        }
    }
    
//    MARK: - Configuring URLRequest
    
    private func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    
    private func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    private func createFormDataBody(_ parameters: Parameters?,
                                        _ boundary: String,
                                        _ data: Data,
                                        _ mimeType: String,
                                        _ filename: String) -> Data {
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
        
        return body as Data
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
