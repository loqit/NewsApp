//
//  Category.swift
//  NewsApp
//
//  Created by Андрей Бобр on 28.12.20.
//

import Foundation

enum Category: String, Codable, CaseIterable {
    case business = "business"
    case entertainment = "entertainment"
    case general = "general"
    case health = "health"
    case science = "science"
    case sports = "sports"
    case technology = "technology"
}
