//
//  Articles.swift
//  NewsApp
//
//  Created by Андрей Бобр on 25.12.20.
//

import Foundation

struct Article: Codable, Hashable {
    
    var source: Source?
    var author, title, articleDescription: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    
    var isBookmark = false
    var id = UUID()
    
    //var hashValue

    init() {}
    
    // Adapter Bookmark to Article
    init(from bookmark: Bookmark) {
        self.init()
        self.title              = bookmark.title
        self.url                = bookmark.url
        self.urlToImage         = bookmark.urlToImage
        self.publishedAt        = bookmark.publishedAt
        self.articleDescription = bookmark.articleDescription
    }
    
    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}


