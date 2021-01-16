//
//  NewsService.swift
//  NewsApp
//
//  Created by Андрей Бобр on 13.01.21.
//

import Foundation

class NewsService: ParseProtocol {
    
    private let networkManager = NetworkManager.shared
    
    func fetchArticles(   type: ScopeOptions,
                          options: RequestOptions,
                          page: Int = 1,
                          completion: @escaping (Result<News, NetworkError>) -> Void) {
        
        switch type {
        case .topHeadline:
            let params = ["q"        : options.keyword,
                          "country"  : options.country.rawValue,
                          "category" : options.category?.rawValue ?? "",
                         // "sources"  : options.source,
                          "pageSize" : options.pageSize,
                          "page"     : page] as [String : Any]

            
            self.networkManager.get(path: .topHeadlinesUrl,
                                    params: params as [String : Any],
                                    completion: completion)
        case .everything:
            let params = ["q"       : options.keyword,
                          "from"    : options.from,
                          "to"      : options.to,
                          "sources"  : options.source,
                          "language": options.language.rawValue,
                          "sortBy"  : options.sortBy.rawValue,
                          "pageSize": options.pageSize,
                          "page"    : page] as [String : Any]
            
            self.networkManager.get(path: .everythingUrl,
                                    params: params as [String : Any],
                                    completion: completion)
        }
        
    }
}

enum Sorting: String, CaseIterable {
    case relevancy
    case popularity
    case publishedAt
}
