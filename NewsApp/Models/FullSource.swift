//
//  FullSource.swift
//  NewsApp
//
//  Created by Андрей Бобр on 28.12.20.
//

import Foundation

struct FullSource: Codable {
    
    let id, name, sourceDescription: String?
    let url: String?
    let category: Category?
    let language, country: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case sourceDescription = "description"
        case url, category, language, country
    }
}
