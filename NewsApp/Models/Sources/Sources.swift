//
//  Sources.swift
//  NewsApp
//
//  Created by Андрей Бобр on 28.12.20.
//

import Foundation

struct Sources: Codable {
    
    let status: String?
    let sources: [FullSource]?
}
