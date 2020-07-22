//
//  TranslationResponse.swift
//  VTB_project
//
//  Created by Gleb Uvarkin on 21.07.2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import Foundation

struct TranslationApiResponse {
    let data: TranslationData
}

extension TranslationApiResponse: Decodable {

    private enum TranslationApiResponseCodingKeys: String, CodingKey {
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TranslationApiResponseCodingKeys.self)

        data = try container.decode(TranslationData.self, forKey: .data)
    }
}

struct TranslationData {
    let translations: [Translation]
}

extension TranslationData: Decodable {

    enum TranslationDataCodingKeys: String, CodingKey {
        case translations = "translations"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TranslationDataCodingKeys.self)

        translations = try container.decode([Translation].self, forKey: .translations)
    }
}

struct Translation {
    let translatedText: String
}

extension Translation: Decodable {

    enum TranslationCodingKeys: String, CodingKey {
        case translatedText = "translatedText"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TranslationCodingKeys.self)

        translatedText = try container.decode(String.self, forKey: .translatedText)
    }
}
