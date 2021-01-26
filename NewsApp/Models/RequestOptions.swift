//
//  RequestOptions.swift
//  NewsApp
//
//  Created by Андрей Бобр on 13.01.21.
//

import Foundation

struct RequestOptions {
    
    var keyword: String = ""
    var country: Country = Country.getCurLocation()
    var category: Category? = nil
    var from: String = ""
    var to: String = ""
    var language: Language = Language.getCurrLanguage()
    var sortBy: Sorting = .publishedAt
    var source: String = ""
    var pageSize: Int = 20
    
}


