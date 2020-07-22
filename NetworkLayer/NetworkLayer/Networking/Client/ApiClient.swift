//
//  NetworkManager.swift
//  NetworkLayer
//
//  Created by Gleb Uvarkin on 25.06.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import Foundation

class ApiClient: NetworkManager {    
    private var clientSettingsProvider: ClientSettingsProviderProtocol
        
//    MARK: - API usage with request and settings
    
    init(provider: ClientSettingsProviderProtocol) {
        clientSettingsProvider = provider
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
            task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        task?.resume()
    }
    
//    MARK: - Converting request in URLRequser
    
    private func buildRequest(from route: Request) throws -> URLRequest {
        
        var request = URLRequest(url: clientSettingsProvider.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20.0)
        
        if let baseHeaders = clientSettingsProvider.settings.baseHeaders {
            addAdditionalHeaders(baseHeaders, request: &request)
        }
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            case .requestParameters(let bodyParameters, let bodyContentType, let urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters, bodyContentType: bodyContentType, urlParameters: urlParameters, request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters, let bodyContentType, let urlParameters, let additionalHeaders):
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters, bodyContentType: bodyContentType, urlParameters: urlParameters, request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
//    MARK: - Configuring URLRequest
    
    private func configureParameters(bodyParameters: Parameters?, bodyContentType: HTTPBodyContentType?, urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            if let bodyContentType = bodyContentType {
                try bodyContentType.encode(urlRequest: &request, bodyParameters: bodyParameters)
            } else {
                try HTTPBodyContentType.jsonEncoded.encode(urlRequest: &request, bodyParameters: bodyParameters)
            }

            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters, isBody: false)
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
}
