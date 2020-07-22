//
//  TranslationClient.swift
//  VTB_project
//
//  Created by Gleb Uvarkin on 21.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import Foundation

class TranslationClient {

    var baseURL = URL(string: "https://google-translate1.p.rapidapi.com")!
    var headers: HTTPHeaders

    private let networkManager: ApiClient
    private var settings: ClientSettings


    init() {
        headers = [
            "x-rapidapi-host": "google-translate1.p.rapidapi.com",
            "x-rapidapi-key": "c8f54d5728mshea7cba09cbc0b85p1dd383jsnc63e2004ce4c",
            "accept-encoding": "application/gzip",
            "content-type": "application/x-www-form-urlencoded"
        ]

        settings = ClientSettings(baseHeaders: headers)
        let provider = HTTPProvider(settings: settings, baseURL: baseURL)
        networkManager = ApiClient(provider: provider)
    }

    func getTranslation(of text: String, from inLanguage: String, to outLanguage: String, completion: @escaping (_ text: String?)->()) {

        let request = Request(path: "/language/translate/v2", httpMethod: .post, task: .requestParameters(bodyParameters: ["source":inLanguage, "q":text, "target":outLanguage], bodyContentType: .urlEncoded, urlParameters: nil))

        networkManager.execute(request: request) {(response, error) in
            if let response = response {
                print(response.statusCode)
                if let data = response.data {
                    do {
                        let apiResponse = try JSONDecoder().decode(TranslationApiResponse.self, from: data)
                        completion(apiResponse.data.translations.first?.translatedText)
                    } catch {
                        print("Can not decode response")
                        completion(nil)
                    }
                }
            } else {
                print("error: response is nil")
                completion(nil)
            }
        }
    }
}
