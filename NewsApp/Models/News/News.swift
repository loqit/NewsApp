//
//  News.swift
//  NewsApp
//
//  Created by Андрей Бобр on 25.12.20.
//

import Foundation

struct News: Codable {
    
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}


